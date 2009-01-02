Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZABJ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZABJ05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZABJ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:26:46 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41373 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZABJ0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:26:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KD6A6VUcCeEC4D72vy2AaISpYDEtKMSJrRSpjS9wfA07y2/+3aWUUduHgVrnvimV8I
         8KbipKTqMtilomkFsqCDY0RWgo42txk6IJqa7uJnsibQPYqzCI0u1Sg8AzlDJ5G6AmMs
         e9kDZgedAcTMXPcErNgoKqT5dRfdXpdthZ2b8=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 2 Jan 2009 10:26:37 +0100
User-Agent: PLD Linux KMail/1.9.10
Cc: Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net>
In-Reply-To: <200901020207.30359.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901021026.37905.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 of January 2009, Rob Landley wrote:
> Before 2.6.25 (specifically git bdc807871d58285737d50dc6163d0feb72cb0dc2 )
> building a Linux kernel never required perl to be installed on the build
> system.  (Various development and debugging scripts were written in perl
> and python and such, but they weren't involved in actually building a
> kernel.) Building a kernel before 2.6.25 could be done with a minimal
> system built from gcc, binutils, bash, make, busybox, uClibc, and the Linux
> kernel, and nothing else.

And now bash is going to be required... while some distros don't need/have 
bash. /bin/sh should be enough.

Heh,
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
