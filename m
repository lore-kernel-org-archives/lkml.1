Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbXE0AO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbXE0AO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXE0AOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:14:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXE0AOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:14:50 -0400
Message-ID: <4658CD70.2080702@zytor.com>
Date: Sat, 26 May 2007 17:14:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <4658C704.2050405@goop.org>
In-Reply-To: <4658C704.2050405@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> I'd really prefer to keep an intact embedded ELF file rather than have a
> semi-ELF file.  That way it would be easier to simply load the image and
> point the normal ELF machinery at some offset into the file rather than
> having to have a special handler for "\x7fBZE" or whatever.
> 

Pardon me for saying it, but it's hardly a hardship to add support for a
single additional constant in existing code.  I'm starting to think this
argument is approaching not just the silly, but downright ridiculous.

Another option is to have the ELF header at a nonzero offset.

	-hpa
