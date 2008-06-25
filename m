Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYFYQPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYFYQPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbYFYQPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:15:05 -0400
Received: from main.gmane.org ([80.91.229.2]:59870 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbYFYQPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:15:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: [GIT PULL] KVM fixes for 2.6.26-rc7
Followup-To: gmane.comp.emulators.kvm.devel
Date: Wed, 25 Jun 2008 18:13:05 +0200
Message-ID: <g3tqqh$dt5$1@ger.gmane.org>
References: <48616182.9030902@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: stgt-4d03bb48.pool.mediaways.net
User-Agent: KNode/0.10.9
Cc: kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:

> Linus, please pull from the repo and branch at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git
> kvm-updates-2.6.26

I just pulled from Linus and now it stalls to boot at

[    0.616031] pnp: PnP ACPI init
[    0.628031] ACPI: bus type pnp registered
[    0.640031] pnp: PnP ACPI: found 7 devices
[    0.652031] ACPI: ACPI bus type pnp unregistered
[    0.660031] SCSI subsystem initialized
[    0.664031] PCI: Using ACPI for IRQ routing
[    0.692031] PCI-GART: No AMD northbridge found.

The kvm process is at 100% time. Taking the many problems I already reported
about, 2.6.26 probably will be entirely broken regarding kvm :(


Thanks,
Bernd




