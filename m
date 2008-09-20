Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYITHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYITHrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYITHri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 03:47:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbYITHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 03:47:38 -0400
Date: Sat, 20 Sep 2008 00:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Steven Noonan" <steven@uplinklabs.net>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Message-Id: <20080920004723.e182ca8b.akpm@linux-foundation.org>
In-Reply-To: <f488382f0809200033x10d43767j95e5958a2715d14c@mail.gmail.com>
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
	<20080919142326.29834d11.akpm@linux-foundation.org>
	<f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com>
	<20080920061659.GF25713@elte.hu>
	<f488382f0809200033x10d43767j95e5958a2715d14c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 00:33:56 -0700 "Steven Noonan" <steven@uplinklabs.net> wrote:

> > yeah. Feel free to send a separate patch that implements Andrew's
> > clean-up suggestion. I agree that pro>con.
> >
> 
> How about this patch gets applied to -tip and I submit one that drops
> the ifdefs on this and the other tracers?

yup.  That's in fact the preferred way of separating patches.  "one
concept per patch" is the old mantra.
