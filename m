Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbXGaXf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbXGaXf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXGaXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:35:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:37044 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXGaXfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:from:cc:content-type:mime-version:references:content-transfer-encoding:message-id:in-reply-to:user-agent;
        b=CjcE+58fVWtsLPxi81aHpfbyg6W+LVs2lgf9iFkw7V5/o23zMzaLHyVM+qpmc4k8dp/DYI+xurSU9aNQrfRQIAsOldJ7uXLgYJvVMMlh4xvLZauCUYerH8moearBStpNCHhLO8rsiO/vsBfVH1nsYAGJzVxD4WtMVXBZPB32jJ8=
Date: Wed, 01 Aug 2007 01:35:11 +0200
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Reboot hang FIXED
From: kriko <kristjan.ugrin@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.twci6be2atcbto@linux.site> <46AF9DC8.7080103@gmail.com> <op.twclwllkatcbto@linux.site> <46AFABE8.7050107@gmail.com> <op.twcmvlvcatcbto@linux.site> <46AFAF4E.1000605@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-ID: <op.twcrsx1yatcbto@linux.site>
In-Reply-To: <46AFAF4E.1000605@gmail.com>
User-Agent: Opera Mail/9.22 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 23:53:18 +0200, Rene Herman <rene.herman@gmail.com>  
wrote:

> Seems a fairly safe assumption that the Linux driver leaves your DVD-ROM  
> in a peculiar state then. If you have both drivers compiled in, I  
> believe the new PATA driver will "win" (judging by the number of people  
> that lost their drives on hda...) so I've added its author to the CC.
>
> Repeating information from your first post:
>
>    Gigabyte gak8nsp (nforce 3)
>
>    NEC DVD-RW@nv_pata
>    1x 80 GB WD@nv_sata, 1x 250 GB WD@nv_sata , IBM (20GB) @ nv_pata
>
> Machine hangs at summary screen where it would be trying a boot from DVD  
> normally on cold boot, or reboot from Windows. reboot=b doesn't help.
>
> Rene.

Sorted out, built 2 kernels, one with old driver, other with only new  
driver. The one with old driver hangs (it could be because  
BLK_DEV_OFFBOARD was enabled?),
using only new drivers works fine.

Thanks for all your help.


-- 
kriko
