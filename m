Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbXKFKqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbXKFKqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXKFKqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:46:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:41503 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXKFKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:46:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Uz20HAOyrUu8DwGB7fsEOA1+xNSlwVV3Yv+Apv0nNg0jWUz074RpnU4eCSLSg69rUk2RMuHTcOZ/s3nEzAcekI6qnPYQfUCxSmCnAk0naETJ8OHYLf3rWOPVOOLKTcvC+ZUo2mkBZdcw1UYr1LiqvxQ2oMpfFlXn+JaxPGesrrI=
Message-ID: <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
Date: Tue, 6 Nov 2007 16:16:21 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc1-git15 Kernel build fails on powerpc - Unrecognized opcode: `dssall'
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <47304343.2010709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47304343.2010709@linux.vnet.ibm.com>
X-Google-Sender-Auth: 559b87958c6e3541
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 4:04 PM, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Hi,
>
> The build fails on the power6 machine while compiling 2.6.24-rc1-git15 kernel,
> with randconfig,
>
>   CHK     include/linux/compile.h
>   AS      arch/powerpc/kernel/swsusp_32.o
> arch/powerpc/kernel/swsusp_32.S: Assembler messages:
> arch/powerpc/kernel/swsusp_32.S:138: Error: Unrecognized opcode: `dssall'
> make[1]: *** [arch/powerpc/kernel/swsusp_32.o] Error 1
> make: *** [arch/powerpc/kernel] Error 2
>

Looks suspiciously like an altivec issue. Could you compile with make
V=1 and/or do a git bisect and see what broke?

Balbir
