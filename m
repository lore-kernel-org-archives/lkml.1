Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYCNICX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYCNICX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYCNICC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:02:02 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:52304 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYCNICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:02:01 -0400
Date: Fri, 14 Mar 2008 04:01:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
In-Reply-To: <20080314054744.GA4216@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.00.0803140359560.31711@localhost.localdomain>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com> <Pine.LNX.4.64.0803140227100.14822@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.00.0803132149320.11864@localhost.localdomain>
 <20080314054744.GA4216@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Alexey Dobriyan wrote:

> On Thu, Mar 13, 2008 at 09:53:01PM -0400, Robert P. J. Day wrote:

> > includes from <linux/percpu.h>:
> >
> >   #include <linux/slab.h>
>
> This needed for kzalloc().

oh, &%^^%*(&^), you're right.  i looked at the comment, where it said
it needed that include for "kmalloc", grepped, didn't see kmalloc so
thought that include was unnecessary.  i didn't even notice the
"kzalloc".  my bad, profuse apologies.  argh.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
