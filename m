Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbXK2Ris@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbXK2Ris (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXK2Ril
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:38:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:59778 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbXK2Rik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:38:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DaRqgniDaTjLY1G6rmx7K2ItM3COXEQT9fr4pnwn4+pqXb0jEdvfrRLGcgV/XMqOngpCfqhUF5lKG2CxS0hw41pt3Ti10dACh+Lbj0QhqHeMnXHGTTBEjsP2mNKV3tCnWew4LS5UsX1dRaXvBP6g7c34FD0s5E6GhGk78HiWfbE=
Message-ID: <2c0942db0711290938q7be4268fg8b1249b24804482f@mail.gmail.com>
Date: Thu, 29 Nov 2007 09:38:37 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: bdupree@techfinesse.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
In-Reply-To: <17931.144.160.98.31.1196356276.squirrel@www.techfinesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46738.67.173.156.207.1196304247.squirrel@www.techfinesse.net>
	 <2c0942db0711290740y7c730fb3te629454462df3efe@mail.gmail.com>
	 <17931.144.160.98.31.1196356276.squirrel@www.techfinesse.net>
X-Google-Sender-Auth: 7d135c6736f25be7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 9:11 AM,  <bdupree@techfinesse.com> wrote:
>
> These are good points. However, on the Slack 10.2 box I repeated these
> measurements with all userspace code quiesced. No daemons running except
> for those that are kernel threads. Secondly, I do run dynticks kernels on
> other Slackware 10.2 boxen without these issues. The hardware may not be
> identical, e.g. Xeons with Intel E7501 chipsets or Opterons with AMD 8131
> chipsets, but I don't see any of this weirdness. Maybe I'll fire up Slack
> 10.2 on spare partition on the other (almost) identical machine and see if
> it exhibits this problem.

Any way you can narrow down the problem space will help, as there are
a lot of variables right now.

Also, please keep the kernel list CC:d so others who are lurking can
see what's going on, and not ask for duplicate data.
