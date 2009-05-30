Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZE3XCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZE3XCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZE3XCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:02:47 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:33048 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZE3XCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:02:47 -0400
Date: Sat, 30 May 2009 16:00:22 -0700
From: "Larry H." <research@subreption.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
Message-ID: <20090530230022.GO6535@oblivion.subreption.com>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:29 Sat 30 May     , Linus Torvalds wrote:
> 
> 
> On Sat, 30 May 2009, Larry H. wrote:
> > 
> > The ZERO_OR_NULL_PTR macro is changed accordingly. This patch does
> > not modify its behavior nor has any performance nor functionality
> > impact.
> 
> I'm sure it makes a code generation difference, with (a) big constants and 
> (b) no longer possible to merge the conditional into one single one.

Like I said in the reply to Peter, this is 3 extra bytes for amd64 with
gcc 4.3.3. I can't be bothered to check other architectures at the
moment.

	Larry
