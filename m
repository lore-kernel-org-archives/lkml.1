Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbXDKMBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbXDKMBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXDKMBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:01:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:61726 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbXDKMB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y8dRqEPwV9Fur6ekzjSj0z36txOzLQTSyuNWQAB4TPHqSF/6TDSNr2O3J2JSPFdMyFx7iINOAK55MELAgnEN//joef2pWgyx8NKYi1uf+EX6LrQLV8mewNhBUrwjMazMofyRF1+FA44GycFyxCfg8c+Lo6hVyQ0Wkgn7vQsA6oo=
Message-ID: <b647ffbd0704110501x79b6dba7rf094113b59016559@mail.gmail.com>
Date: Wed, 11 Apr 2007 14:01:27 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "surya.prabhakar@wipro.com" <surya.prabhakar@wipro.com>
Subject: Re: rsdl:mouse freezing while doing git-gc
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1176279462.8833.8.camel@bluegenie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176279462.8833.8.camel@bluegenie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/07, surya.prabhakar@wipro.com <surya.prabhakar@wipro.com> wrote:
> Hi,
>    I am using the kernel 2.6.21-rc4-rsdl. Machine is a P4 2.2 ghz with
> 512mb ram. While doing a git-gc with nice 19 , I am still seeing that my
> mouse keeps freezing occasionally and other windows do not respond
> immediately.
>
> I have included the top output below.
>
> kindly update me if any additional information is required.
>

btw, it's sd-0.39, isn't?

Hum... according to Con's "priority matrix" table, a nice 19 task can
run only one priority slot per major rotation and this slot is fixed
(20). So I'd expect "top" showing the same value in "PR" for all the
tasks with "NI" == 19 and this is not a case in your case (see an
excerpt from your output below).

Either I'm still missing something important or there is something
fishy here.. will try to look at the code a bit later.

tasks with NI==19 show different "PR"s

>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+
> COMMAND
> 12367 surya      0  19  309m 213m 151m D 29.6 43.2   0:56.94
> git-pack-object
>     3 root       0  19     0    0    0 S  0.0  0.0   0:00.13
> ksoftirqd/0
> 12354 surya     20  19  3684  484  484 S  0.0  0.1   0:00.00
> git-gc
> 12357 surya     20  19  4440  684  684 S  0.0  0.1   0:00.06
> git-repack
> 12366 surya     20  19  4440  228  228 S  0.0  0.0   0:00.00
> git-repack


-- 
Best regards,
Dmitry Adamushko
