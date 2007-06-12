Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXFLNzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXFLNzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbXFLNy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:54:59 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:24932 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbXFLNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HFvaOA1yBzEmSXKXhH5XTM/VVmb/+Staxhj0STren6Dt1CCCNcHG2BhFR0pdWzdl6oKMA7PFWtsJzEGKm102svSc9c7PdrFHsT1iXrS5VHFMlqM0uVoi5Hl/0F8uKsEtEOfpdhQJaZWZp5qYT5zjGBGo39d0HSKi8g1yGuqhGj8=
Message-ID: <7f7732360706120654i34f34da8q6428e41bc5a76728@mail.gmail.com>
Date: Tue, 12 Jun 2007 15:54:57 +0200
From: "Federico Paparoni" <federico.paparoni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux kernel 2.4 programming problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
i'm trying to create a simple system call in a kernel 2.4 distribution.
I read guide/articles like this

http://irfanhabib.wordpress.com/2006/10/01/adding-a-system-call-linux-24x/

All the articles say the same things, but the implementation of my new
system call doesn't work.
I create a new entry in arch/i386/kernel/entry.S
I create a new entry in include/asm/unistd.h
I create a new function with the asmlinkage prefix in a source file
already defined (in ipc/sem.c for example)

When i create my user program, it doesn't work. Firstly when i try to
compile i receive a problem like this

: undefined reference to 'errno'

Then I include errno.h (also if i don't understand this step) and the
compilation works, but the syscall neverworks, because the call always
return -1.

Any help?
Any tutorial FOR DUMMY MAN that someone already used?

Cheers

Federico
