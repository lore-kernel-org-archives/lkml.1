Return-Path: <linux-kernel-owner+w=401wt.eu-S934834AbZKYRTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834AbZKYRTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbZKYRTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:19:53 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38282 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735AbZKYRTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:19:50 -0500
Message-ID: <4B0D6735.8000604@garzik.org>
Date: Wed, 25 Nov 2009 12:19:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 12:02 PM, Bartlomiej Zolnierkiewicz wrote:
> I've been going through PATA drivers for the last few days to make
> sure that we offer similar level of hardware support in the new PATA
> drivers as with the old IDE subsystem and the following patchset is
> the end result of said audit.

Thanks!

> - add 32-bit PIO support for more controllers
>
>    ( pata_artop, pata_atiixp, pata_efar, pata_cmd64x, pata_cs5520,
>      pata_cs5530, pata_cs5535, pata_cypress, pata_hpt366, pata_hpt37x,
>      pata_hpt3x2n, pata_it8213, pata_it821x, pata_jmicron, pata_ns87415,
>      pata_opti, pata_pdc2027x, pata_pdc202xx_old, pata_rz1000,
>      pata_sc1200, pata_scc, pata_sch, pata_serverworks, pata_sl82c105,
>      pata_sis, pata_triflex&  pata_via )

This should be all in one patch.

I'll let the comments from Alan and others trickle in before applying...

> - add ->init_host method for abstracting host specific controller
>   initialization and then use it to cleanup Power Managment code
>   resulting in over 100 LOC gone
>
>   ( pata_ali, pata_amd, pata_artop, pata_cmd640, pata_cmd64x,
>     pata_cs5530, pata_hpt366, pata_hpt3x3, pata_it821x, pata_ninja32,
>     pata_ns87415, pata_pdc2027x & sata_sil )

hmmmm....  will reserve comment until I review it thoroughly, but I am a 
bit reluctant to move away from the current struct-driver style driver 
init/setup model.

	Jeff



