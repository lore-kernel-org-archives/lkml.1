Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYE3UAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYE3UAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYE3UA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:00:29 -0400
Received: from 1wt.eu ([62.212.114.60]:1347 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYE3UA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:00:29 -0400
Date: Fri, 30 May 2008 21:59:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Marco <marco@tampabay.rr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New Kernel headers vs old Kernel headers
Message-ID: <20080530195941.GC5609@1wt.eu>
References: <4840395A.108@tampabay.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4840395A.108@tampabay.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 01:28:58PM -0400, Marco wrote:
> Hello All,
> 
> I've come across a little discrepancy between the glibc docs and linux
> kernel docs when I was trying to figure out what kernel headers I should
> being using for my cross compiling.  The docs seem to say almost exactly
> the opposite thing.
> 
> For a quick summary: linux docs(headers_install.txt) seem to indicate,
> running glibc compiled against new kernel headers, on an older kernel
> will possibly cause problems.  Where as glib docs(FAQ) indicate glibc
> compiled against new kernel headers, will run fine on an older kernel.
> 
> Can someone shed some light on this (i.e. which is right)?
> 
> Thank you in advance
> 
> Marco Fonseca
> 
> (p.s. I've included the sections from both docs below for easy reference)

IMHO and from experience, the kernel's version is the right one. Also,
it makes some sense, considering that even if you try to run an old
binary on a recent kernel, it generally works while the other way around
is not always true. Note however that what is said in glibc's doc mostly
talks about missing features. They may consider that the glibc offers an
abstraction between the application and the kernel, so that it should be
transparent to the application.

I think the right approach is to base your work on the oldest kernel you
intend to support. That way you'll get most features with the maximum
guarantee of backwards compatibility.

Willy

