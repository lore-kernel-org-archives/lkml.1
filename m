Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZCTQcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZCTQcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZCTQcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:32:11 -0400
Received: from emulex.emulex.com ([138.239.112.1]:62970 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZCTQcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:32:09 -0400
From: Chetan.Loke@Emulex.Com
To: <yu.zhao@intel.com>, <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Date: Fri, 20 Mar 2009 09:32:04 -0700
Subject: RE: [PATCH v12 7/8] PCI: document SR-IOV sysfs entries
Thread-Topic: [PATCH v12 7/8] PCI: document SR-IOV sysfs entries
Thread-Index: AcmpDBQkrk0DmoHeRQiwQZGNTBmjsAAbDygA
Message-ID: <BD597E014482714090555A6376F9CA8B771BA3D0EC@EXMAIL.ad.emulex.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
 <1237519518-24048-8-git-send-email-yu.zhao@intel.com>
In-Reply-To: <1237519518-24048-8-git-send-email-yu.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Mar 2009 16:32:06.0382 (UTC) FILETIME=[685CD0E0:01C9A979]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-owner@vger.kernel.org wrote:
> Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |   27
> +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci
> b/Documentation/ABI/testing/sysfs-bus-pci
> index e638e15..36edf03 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci


A very handy feature would be the ability to send Resets(BME etc) via a sysfs-entry to all the VF's attached to a PF. This way one can test the drivers/firmware really easily. 

BME
  |
  |->PF 
 	|->VF0
	|->VF1
      ..
      |->VFn


Thanks
Chetan