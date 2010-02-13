Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0BMBmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:42:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:38332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0BMBkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208";a="772528609"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:38 -0800
Subject: [PATCH 0/8] x86 moorestown enabling patches
Thread-Topic: [PATCH 0/8] x86 moorestown enabling patches
Thread-Index: AcqsTYuSLsoRc6dpRB+zCtOX+e+1pA==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D06@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resubmission of Moorestown enabling patch series. The series has been
simplified significantly after x86_init abstraction is introduced.

Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
Internet Device(MID) platform. Moorestown consists of two chips:
Lincroft (CPU core, graphics, and memory controller) and Langwell IOH.
Unlike standard x86 PCs, Moorestown does not have many legacy devices
nor standard legacy replacement devices/features. e.g. Moorestown does
not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.

0001-x86-ioapic-early-enable-ioapic-for-timer-irq.patch
0002-x86-PCI-Moorestown-PCI-support.patch
0003-x86-mrst-add-dummy-legacy-pic-to-platform-setup.patch
0004-x86-mrst-Fill-in-PCI-functions-in-x86_init-layer.patch
0005-x86-mrst-add-platform-timer-info-parsing-code.patch
0006-x86-mrst-add-vrtc-platform-data-setup-code.patch
0007-x86-apbt-Moorestown-APB-system-timer-driver.patch
0008-x86-mrst-platform-clock-setup-code.patch

Jacob
