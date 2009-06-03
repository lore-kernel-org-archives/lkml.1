Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZFCBYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZFCBYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 21:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZFCBYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 21:24:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:9894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZFCBYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 21:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,294,1241420400"; 
   d="scan'208";a="418360961"
Subject: Re: ACPI Exception (evregion-0422): AE_ERROR, Returned by Handler
	for [PCI_Config] [20090320]
From: Zhang Rui <rui.zhang@intel.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30906021102h43b8ecc4u9e67687de129bca1@mail.gmail.com>
References: <dd18b0c30906021102h43b8ecc4u9e67687de129bca1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 09:24:46 +0800
Message-Id: <1243992286.9076.5.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 02:02 +0800, Justin Mattock wrote:
> I posted this error a few weeks ago, but had no response.
> So after a few weeks of looking at this, I wanted to find out if
> this is safe to see this, or should I be concerned:
> 
> [    5.868418] ACPI: Power Button [PWRB]
> [    5.868547] input: Sleep Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
> [    5.868621] ACPI: Sleep Button [SLPB]
> [    6.093547] ACPI Exception (evregion-0422): AE_ERROR, Returned by
> Handler for [PCI_Config] [20090320]
> [    6.093555] ACPI Error (psparse-0537): Method parse/execution
> failed [\_SB_.PCI0.RP01.GFX0._PS0] (Node f703dcc0), AE_ERROR
> [    6.093614] ACPI: Transitioning device [GFX0] to D0
> 
> I did do a dsdt dump, and looked for any errors
> but none had shown up.
> kernels that I have seen this are 2.6.29 -
> 2.6.30-rc5
> 
please file a new bug report at
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and attach the full dmesg output and acpidump there.

thanks,
rui

