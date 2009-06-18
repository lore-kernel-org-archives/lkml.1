Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZFRT5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZFRT5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZFRT5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:57:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:11769 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZFRT5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:57:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="156152159"
Date: Thu, 18 Jun 2009 12:57:33 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: kaneshige.kenji@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH next] PCI hotplug: fix build when !SYSFS
Message-ID: <20090618125733.254ffa0d@jbarnes-g45>
In-Reply-To: <1245241397-6781-1-git-send-email-a.beregalov@gmail.com>
References: <1245241397-6781-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 16:23:17 +0400
Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Fix this build error when CONFIG_SYSFS is not set:
> drivers/pci/slot.c: In function 'pci_hp_create_module_link':
> drivers/pci/slot.c:327: error: 'module_kset' undeclared
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>  drivers/pci/slot.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

Thanks Alexander, but this one has been obsoleted by the one from Alex
Chiang, which describes the dependencies in Kconfig instead...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
