Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbXIUNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbXIUNJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXIUNJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:09:43 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49285 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXIUNJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:09:42 -0400
Date: Fri, 21 Sep 2007 15:09:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Satyam Sharma <satyam@infradead.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: error from checkpatch.pl version 0.10
In-Reply-To: <20070920155302.GA29224@shadowen.org>
Message-ID: <Pine.LNX.4.64.0709211508480.30810@fbirervta.pbzchgretzou.qr>
References: <200709202156.GFC11109.HOFQLOVOFFtSJM@I-love.SAKURA.ne.jp>
 <alpine.LFD.0.999.0709201916400.17093@enigma.security.iitk.ac.in>
 <20070920155302.GA29224@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 20 2007 16:53, Andy Whitcroft wrote:
>> >   ERROR: need consistent spacing around '*' (ctx:WxV)
>> >   #2334: FILE: security/tomoyo/common.c:2306:
>> >   +static unsigned int tmy_poll(struct file *file, poll_table *wait)
>> >                                                               ^
>> 
>> Looks like a checkpatch.pl bug to me -- that was nothing to warn about.
>
>Hmm yeah this is a false positive, its hard to detect correctly.  Some
>fool decided to use * as both a unary and binary operator and made life
>very hard indeed.

The C parser has no problem with it :p
It is simple: there cannot be a binary * operator in the argument list.
