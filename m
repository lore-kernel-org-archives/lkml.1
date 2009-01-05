Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZAESP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZAESP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZAESPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:15:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZAESPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:15:05 -0500
Date: Mon, 5 Jan 2009 13:15:02 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: .28-git compile failure in drivers/pci/dmar.c
Message-ID: <20090105181502.GA13093@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci/dmar.c:510: undefined reference to `iommu_calculate_agaw'

The config that seems to upset it is..

# CONFIG_DMAR is not set
CONFIG_INTR_REMAP=y

	Dave

-- 
http://www.codemonkey.org.uk
