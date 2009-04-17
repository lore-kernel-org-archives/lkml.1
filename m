Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbZDQAqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbZDQAqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbZDQAl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:41:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:41720 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760595AbZDQAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:41:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,201,1239001200"; 
   d="scan'208";a="132442690"
Subject: Re: [BISECTED] [REGRESSION] "ACPI video: support _BQC/_BCL/_BCM
	methods that use index values" breaks ACPI video
From: yakui_zhao <yakui.zhao@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239881839.5981.4.camel@maxim-laptop>
References: <1239881839.5981.4.camel@maxim-laptop>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Fri, 17 Apr 2009 08:42:36 +0800
Message-Id: <1239928956.3638.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 19:37 +0800, Maxim Levitsky wrote:
> I finally bisected a acpi video regression on my aspire 5720G
> 
> Reverting commit 
> 
> "ACPI video: support _BQC/_BCL/_BCM methods that use index values"
> commit 1a7c618a3f7bef1a20ae740df512eeba21397fa5.
> 
> 
> Makes it work, otherwise /sys/class/backlight is empty, and I get error
> messages when I press hardware keys to change brightness:
> 
> "ACPI: Failed to switch the brightness"
Will you please file a new bug at
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and attach the output of acpidump, dmidecode?

thanks.
> 
> 
> Best regards,
> 	Maxim Levitsky
> 

