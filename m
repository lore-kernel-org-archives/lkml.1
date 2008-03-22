Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYCVHPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYCVHPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 03:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYCVHPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 03:15:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58089 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYCVHPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 03:15:04 -0400
Date: Sat, 22 Mar 2008 08:17:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080322071755.GP2346@one.firstfloor.org>
References: <20080318095715.27120788.akpm@linux-foundation.org> <20080318172045.GI11966@one.firstfloor.org> <20080318104437.966c10ec.akpm@linux-foundation.org> <20080319083228.GM11966@one.firstfloor.org> <20080319020440.80379d50.akpm@linux-foundation.org> <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com> <20080320090005.GA25734@one.firstfloor.org> <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com> <20080321172644.GG2346@one.firstfloor.org> <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 09:36:51PM -0700, Ulrich Drepper wrote:
> On Fri, Mar 21, 2008 at 10:26 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >  Concrete suggestions please.
> 
> I already spelled it out.  Add a new program header entry, point it to
> a bit array large enough to cover all loadable segments.

Ah that's easy, the program header is already supported in the kernel code
(PT_PRESENT_BITMAP)

The additional SHDR is just there for easier testing/migration.
> 
> It is not worth creating problems with this invalid extension just for

You still didn't say why it was invalid.

Anyways I disagree on the value of supporting old binaries. I believe
it is important.

-Andi
