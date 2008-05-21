Return-Path: <linux-kernel-owner+w=401wt.eu-S934616AbYEUA5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616AbYEUA5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762300AbYEUA5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:57:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54830 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbYEUA47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:56:59 -0400
Date: Wed, 21 May 2008 01:56:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] or51132.c: unaligned
Message-ID: <20080521005657.GG28946@ZenIV.linux.org.uk>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk> <1211330472.5915.228.camel@brick> <20080521004548.GD28946@ZenIV.linux.org.uk> <1211331088.5915.241.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211331088.5915.241.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:51:28PM -0700, Harvey Harrison wrote:

> > ... and the point of that would be?  FWIW, I really don't like the ...p()
> > forms - they are hard to distinguish from normal ones visually and any
> > possible performance benefit is too small for most of the uses.  IOW,
> > it's mostly redundant API.
> 
> I sent a patchset getting rid of the p variants earlier today, Dave
> Miller made a good point that some arches have well optimized versions
> of these as they have specific machine instructions they can use.

Thus the "mostly" part - on hot paths the microoptimization is worth the
trouble.  None of the places in question is on such paths...
