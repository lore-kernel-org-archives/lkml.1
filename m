Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYJMTkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYJMTkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYJMTkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:40:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:63025 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbYJMTkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kuHZBz8VpCCsJSWKcB4UcbSoTFATAzz4R7laIu8AIwdaYZCUhxF9m5DS5sn22rhzRi
         MfWD0Qhc3PKcxKVrn1K0cFANzunbmqVTctNoBGkGgz2sy3yW6p4LiLX/p48rsaDEG3Po
         CJcct0pICBsVuM9ZexYGWvAr9Kk3tgJQhcQ1U=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: oops while booting with recent git kernel (pci_subsys_init?)
Date: Mon, 13 Oct 2008 21:36:50 +0200
User-Agent: PLD Linux KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200810121227.09114.a.miskiewicz@gmail.com> <a8e1da0810122227g3c44a4c1w7ee4d8a4e7548872@mail.gmail.com>
In-Reply-To: <a8e1da0810122227g3c44a4c1w7ee4d8a4e7548872@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810132136.50871.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 of October 2008, Dave Young wrote:
> On Sun, Oct 12, 2008 at 6:27 PM, Arkadiusz Miskiewicz
>
> <a.miskiewicz@gmail.com> wrote:
> > Not sure if it's worth to report this before all initial merges happen
> > but here it is anyway.
>
> I saw similar oops while "reboot" with eip "strnlen", but only once.
> My kernel version is 2.6.27

Just tested with today git (latest commit is):

commit a447c0932445f92ce6f4c1bd020f62c5097a7842
Author: Steven Whitehouse <swhiteho@redhat.com>
Date:   Mon Oct 13 10:46:57 2008 +0100

and the oops still happens, so I guess this is real problem.

> > git kernel with latest commit:
> > commit fd048088306656824958e7783ffcee27e241b361
> > Date:   Sat Oct 11 13:23:48 2008 -0700
> >
> > booted on thinkpad z60m results with such oops:
> > http://carme.pld-linux.org/~arekm/img_2325_small.png
> >
> > Config used:
> > http://carme.pld-linux.org/~arekm/img_2325_small.config


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
