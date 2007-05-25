Return-Path: <linux-kernel-owner+w=401wt.eu-S1765512AbXEYVcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765512AbXEYVcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758932AbXEYVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:32:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51992 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbXEYVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:32:14 -0400
Date: Fri, 25 May 2007 22:32:13 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: double exclamation (!!) suckage in the kernel
Message-ID: <20070525213213.GM4095@ftp.linux.org.uk>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com> <20070525204127.GK4095@ftp.linux.org.uk> <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 02:26:11AM +0530, Satyam Sharma wrote:
> also be brave enough to take a C quiz here :-)
> 
> >        what type should x have for !!x to be a valid expression?
> 
> Any integer type (includes pointers)

Er, no...  Pointers are not integer types *and* you can use ! on any
scalar type (including floating ones, even though it's not particulary
useful there).

> >        what will be the type of result?
> 
> int (I guess boolean for C99?)

Actually, ! and comparisons still give int in C99 (and !x is defined as
(x == 0) in all situations).
