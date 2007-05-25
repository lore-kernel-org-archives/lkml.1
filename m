Return-Path: <linux-kernel-owner+w=401wt.eu-S1765137AbXEYVg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765137AbXEYVg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXEYVgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:36:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45989 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbXEYVgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:36:50 -0400
Date: Fri, 25 May 2007 22:36:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: double exclamation (!!) suckage in the kernel
Message-ID: <20070525213649.GN4095@ftp.linux.org.uk>
References: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com> <20070525204127.GK4095@ftp.linux.org.uk> <a781481a0705251356s2e9e0e2dsbed40a84231cd4fa@mail.gmail.com> <20070525213213.GM4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525213213.GM4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:32:13PM +0100, Al Viro wrote:
> On Sat, May 26, 2007 at 02:26:11AM +0530, Satyam Sharma wrote:
> > also be brave enough to take a C quiz here :-)
> > 
> > >        what type should x have for !!x to be a valid expression?
> > 
> > Any integer type (includes pointers)
> 
> Er, no...  Pointers are not integer types *and* you can use ! on any
> scalar type (including floating ones, even though it's not particulary
> useful there).

... which means that original question ("what type should x have...")
gets the answer "scalars, arrays or functions".  The last two variants
give you constant 1, though (arrays and functions decay to pointers in
such context and that pointer is not going to be different from null
pointer of the same type; thus you get !!x => !0 => 1).
