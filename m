Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZF3RbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZF3RbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZF3Ra7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:30:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:54821 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZF3Ra6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:30:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,317,1243839600"; 
   d="scan'208";a="529110731"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jun 2009 10:31:01 -0700
Subject: RE: [PATCH] x86/ia64: adjust section annotation for	 pcibios_setup()
Thread-Topic: [PATCH] x86/ia64: adjust section annotation for
	 pcibios_setup()
Thread-Index: Acn5dU1KrPcDn63ySLiQN4cf1EDcTgAMv5BA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3A8D9EA80@orsmsx505.amr.corp.intel.com>
References: <4A4A11AF020000780000831D@vpn.id2.novell.com>
In-Reply-To: <4A4A11AF020000780000831D@vpn.id2.novell.com>
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

--- linux-2.6.31-rc1/arch/ia64/pci/pci.c	2009-06-26 17:49:37.000000000 +0200
+++ 2.6.31-rc1-pcibios_setup/arch/ia64/pci/pci.c	2009-05-04 11:39:32.000000000 +0200
@@ -537,7 +537,7 @@ pcibios_align_resource (void *data, stru
 /*
  * PCI BIOS setup, always defaults to SAL interface
  */
-char * __devinit
+char * __init
 pcibios_setup (char *str)
 {
 	return str;

ia64 part Acked-by: Tony Luck <tony.luck@intel.com>

Ingo/Thomas/Peter: please run this through the tip tree.

Thanks

-Tony
