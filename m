Return-Path: <linux-kernel-owner+w=401wt.eu-S933385AbXHaVWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385AbXHaVWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965226AbXHaVWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:22:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:38924 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965166AbXHaVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fsKwfPwrT1YHyF3Zc1QnDtXkf9ET0kNpR9BZLJLmtfm82kY0l2PwmDu/0wUy5pH6bOtCw4rP4yKLQFVMm6b8UFMTiUIfnbeNKniL38SAxZicnKoY4r96DBjBiMuu36MwoZ5qCjHIhX4dLVMAvB1mQClEGUGrEaddELvVF5pbrJk=
Message-ID: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
Date: Fri, 31 Aug 2007 17:22:19 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: the Linux kernel, testsuites, and maybe *you*
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

is there any sort of standard for testing and integration into
mainline ?  in the Blackfin world, we've been developing little
external kernel modules and adding them to our own testsuite, but
often times these things are not Blackfin specific.  case in point,
we're integrating a string testsuite to make sure all of the fun str*
and mem* functions are sane and operate as they expected, but rather
than having just Blackfin benefit here, i'd like to see this pushed
upstream ...

i'm fully aware of LTP (as i work on it), but i feel that serves a
great purpose for exercising the API/ABI exposed to userspace either
directly through the kernel or indirectly through the system libc ...
it isnt a very good tool for testing kernel internals, especially as
the kernel changes and evolves.

is there a framework already in place i'm not aware of ?  should there
be ?  should this all live in LTP ?  i wouldnt mind an option under
kernel hacking "Enable testsuites" ... as far as i can tell, the
testing process is really based extensively on feedback from people,
nothing really automated.
-mike
