Return-Path: <linux-kernel-owner+w=401wt.eu-S1761768AbXHEUOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768AbXHEUOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXHEUOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:14:46 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:46785 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbXHEUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:14:45 -0400
Date: Sun, 5 Aug 2007 22:14:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: =?iso-8859-1?Q?J=F6rg?= Hoffmann <jh2000@root24.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] panic.c
Message-ID: <20070805201428.GA18654@osiris.ibm.com>
References: <006701c7d775$53137cc0$6800a8c0@jhnotebook> <Pine.LNX.4.64.0708051731050.29913@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0708051731050.29913@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >The idea behind this is to keep the power usage on panic’d machines
> >(without auto-reboot) low. Another point is in an Virtual Machine
> >environment the process of the VM is using 100% of the host-cpu. This
> >would stuck other programs or VMs. This patch brings the VM to stop and
> >keeps the cpu usage below 1%.

For VM environments it would be better to have an interface that tells
the hypervisor that your guest is dead. That's what the disabled_wait()
line in panic() is good for on s390.
