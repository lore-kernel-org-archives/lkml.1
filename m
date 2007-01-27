Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbXA0VqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbXA0VqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXA0VqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:46:21 -0500
Received: from mail.enter.net ([216.193.128.40]:50867 "EHLO mmail.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbXA0VqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:46:21 -0500
From: "D. Hazelton" <dhazelton@enter.net>
To: caglar@pardus.org.tr
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
Date: Sat, 27 Jan 2007 16:46:18 -0500
User-Agent: KMail/1.9.5
Cc: Avi Kivity <avi@qumranet.com>, lkml <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
References: <200701260140.47760.caglar@pardus.org.tr> <45BB15F1.6020600@qumranet.com> <200701272328.31532.caglar@pardus.org.tr>
In-Reply-To: <200701272328.31532.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701271646.19067.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 January 2007 16:28, S.Çağlar Onur wrote:
> 27 Oca 2007 Cts tarihinde, Avi Kivity şunları yazmıştı:
> > The patch looks correct, but I don't understand the gcc error message.
> > Are we sure this isn't a gcc 4.2 bug?
> >
> > "g" appears to be equivalent to "rmi", if "i" is impossible, gcc is free
> > to use "r" or "m", no?
>
> Accorgind to GCC devs. its not a bug
> (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29808), on comment #5 the
> problem described like;
>
> "g" means "r"+"i" so the register allocator in the -O0 case is selecting
> "r" while in the optimize case is selecting "i"

Sounds like a bug to me! After all, shouldn't the different sections of code 
be selecting the *same* bits ?

DRH
