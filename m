Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYFSG1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYFSG1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYFSG1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:27:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56003 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYFSG1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:27:02 -0400
Date: Thu, 19 Jun 2008 08:27:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Neil Brown <neilb@suse.de>
cc: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Raid auto-assembly on LDM?
In-Reply-To: <18521.57487.410817.953075@notabene.brown>
Message-ID: <alpine.LNX.1.10.0806190826370.14231@fbirervta.pbzchgretzou.qr>
References: <485577EE.9050806@kcore.org> <18521.57487.410817.953075@notabene.brown>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-06-19 06:29, Neil Brown wrote:
>On Sunday June 15, ml_linuxkernel_20060528@kcore.org wrote:
>> Hello folks,
>> 
>> I'm trying something which is probably slightly crazy, but I can't get it to work.
>> 
>> What I'm trying is to get the linux kernel to auto-assembly my raid-1 sets, 
>> which are based on volumes on two LDM disks.
>> 
>> The problem is that the kernel looks for partitiontypes of 0xfd, which I can't 
>> set (or haven't found yet how to set) for LDM volumes. The assembly fails, and 
>> the kernel panics.
>
>Sorry, acronym failure:  What is LDM??

Logical Device Manager... that Windows thing (CONFIG_LDM_PARTITION)
