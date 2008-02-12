Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYBLBKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYBLBKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYBLBJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:09:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbYBLBJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:09:57 -0500
Date: Mon, 11 Feb 2008 17:09:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: greg@kroah.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86_64: check msr to get mmconfig for amd family
 10h opteron v3
Message-Id: <20080211170944.8b567a89.akpm@linux-foundation.org>
In-Reply-To: <200802111648.35299.yinghai.lu@sun.com>
References: <200802111643.17265.yinghai.lu@sun.com>
	<200802111645.38984.yinghai.lu@sun.com>
	<200802111647.11154.yinghai.lu@sun.com>
	<200802111648.35299.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 16:48:35 -0800
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> 
> so even booting kernel with acpi=off or even MCFG is not there, we still can
> use MMCONFIG.
> 

This patch threw a big reject.  I didn't check why.


> +		pci_direct_conf1.read(0, bus, devfn, 0, 4, &l);

When I fixed the reject, compilation failed here.

arch/x86/pci/mmconfig-shared.c: In function 'pci_mmcfg_check_hostbridge':
arch/x86/pci/mmconfig-shared.c:214: error: 'pci_direct_conf1' undeclared (first use in this function)


What kernel are you patching?
