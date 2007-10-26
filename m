Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbXJZXWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbXJZXWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXJZXWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:22:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXJZXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:22:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: CSights <csights@fastmail.fm>
Subject: Re: cannot "hibernate" if program being debugged in gdb is paused after SIGABRT in linux 2.6.23 (but can in 2.6.22.7)
Date: Sat, 27 Oct 2007 01:38:15 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200710252103.27675.csights@fastmail.fm>
In-Reply-To: <200710252103.27675.csights@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710270138.15982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 26 October 2007 03:03, CSights wrote:
> Hi LKML,
> 	My computer running kernel 2.6.23 does not "hibernate" (suspend to disk using 
> the kernel's methods) with a program (named stringTest) running in gdb, but 
> has received a SIGABRT.
> 	The hibernate is successful when running kernel 2.6.22.7 !

Certainly one of the freezer changes in 2.6.23 has caused that to happen ...

> Here is the message from gdb:
> 
> terminate called after throwing an instance of 'std::out_of_range'
>   what():  basic_string::substr
> 
> Program received signal SIGABRT, Aborted.
> 0xb7fb6410 in __kernel_vsyscall ()
> 
> And the attached file is the portion of /var/log/syslog when the hibernate was 
> attempted.
> 
> Let me know if there is anything else to send,

Well, a test program that triggers the SIGABRT under gdb would be useful.

Greetings,
Rafael
