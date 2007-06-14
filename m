Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXFNWQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXFNWQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbXFNWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:13:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757256AbXFNWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:13:20 -0400
Date: Thu, 14 Jun 2007 15:12:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rich Coe <Richard.Coe@med.ge.com>
cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: RFC: Re: PATCH: udf fs corruption on linux-2.6
In-Reply-To: <20070614163218.1d75dda4.Richard.Coe@med.ge.com>
Message-ID: <alpine.LFD.0.98.0706141511110.14121@woody.linux-foundation.org>
References: <20070613154803.a1ad874a.Richard.Coe@med.ge.com>
 <20070614163218.1d75dda4.Richard.Coe@med.ge.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Rich Coe wrote:
>
> I've updated the patch below to use drop_inode rather than put_inode.
> 
> drop_inode is only called when the last iput() reference to the inode is
> released, where put_inode is called for every iput().

Patch looks fine, but this late in the -rc series, I'd really like to get 
an ACK from Jan or somebody else, just to make sure there are no other 
issues with it.

Jan? 

		Linus
