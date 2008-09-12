Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYILFVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYILFVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 01:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYILFVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 01:21:44 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:7302 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYILFVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 01:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QHZ+OKgiZWI13Nen1+aoWbZdEHSKW84xV8mMM/PN8Y391unIu5JjbdbxB2Kp8DpMy9
         TCd/cB0LcryBBgRDjgqKAgZIsoOUHc61VRcm0B7iiY6uKpMSMB0rpe1FKc/8vF3a0i7G
         cicmGqeUX3W/Cexj95zA9doF9RaNgr1zvK9LA=
Message-ID: <2cf1ee820809112221w213aa929x32905e1c25897cf3@mail.gmail.com>
Date: Fri, 12 Sep 2008 08:21:36 +0300
From: "emin ak" <eminak71@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Building Kernel with -O0
Cc: 7eggert@gmx.de
In-Reply-To: <E1KdOFZ-0001Q4-So@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b8rB2-6BM-1@gated-at.bofh.it> <badXc-7gl-21@gated-at.bofh.it>
	 <baf2M-bE-7@gated-at.bofh.it> <bagBJ-20J-7@gated-at.bofh.it>
	 <E1KdOFZ-0001Q4-So@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/10 Bodo Eggert <7eggert@gmx.de>:
> linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>
>> If you have to single-step through kernel procedures, you
>> are not writing proper code for a kernel. Furthermore, even
>> when using the kernel debugger, you are not executing the
>> exact same path that would be executed without the debugger
>> attached.
>
> I sometimes single-step in order to verify my (userspace) code, instead of
> just throwing random test data at it. It's easier and makes me feel better.
> OTOH, -O2 never was a problem if I used it, so I don't strongly vote
> for enabling -O0.
>
> --

I had compiled linux-2.6.23 with -O0 for kgdb only with little
modifications, it's  running with no error for a long time. I'am not a
linux expert, I think talented kernel hackers can make kernel to
compile with -O0 easly but for some reason they dont want to do it.
Debug is much understandable for me (and for most people I think) with
-O0. Linux kernel programming ability is not a gift, of course you can
learn the code with printks and reading, but which age are we living
in?

Emin
