Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXGPJNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXGPJNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXGPJNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:13:13 -0400
Received: from mail.suse.de ([195.135.220.2]:57710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbXGPJNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:13:10 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Al Viro <viro@ftp.linux.org.uk>,
       Nicholas Miell <nmiell@comcast.net>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr>
	<20070715205313.GE21668@ftp.linux.org.uk>
	<1184534001.2765.5.camel@entropy>
	<20070715222323.GG21668@ftp.linux.org.uk>
	<Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr>
	<469B2CAE.9010101@goop.org>
X-Yow: How do I get HOME?
Date: Mon, 16 Jul 2007 11:12:51 +0200
In-Reply-To: <469B2CAE.9010101@goop.org> (Jeremy Fitzhardinge's message of
	"Mon\, 16 Jul 2007 01\:30\:38 -0700")
Message-ID: <jey7hgbtkc.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> This should work:
>
>    fchdir(fd1);
>    open("file1", O_RDWR | O_CREAT);
>    fchdir(fd2);
>    open("file2", O_RDWR | O_CREAT);

This is not thread-safe.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
