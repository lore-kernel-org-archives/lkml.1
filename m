Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZITJuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZITJuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 05:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZITJuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 05:50:03 -0400
Received: from lo.gmane.org ([80.91.229.12]:58183 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbZITJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 05:50:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: it87 sensors need an ACPI driver (2.6.31)
Date: Sun, 20 Sep 2009 11:10:22 +0200
Organization: The Fists of the White Lotus
Message-ID: <pan.2009.09.20.09.10.22.472125@googlemail.com>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-12.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: lm-sensors@lm-sensors.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 10:20:57 +0200, wixor wrote:

> Hello,
> with recent upgrade to 2.6.31 I get
> 
> it87: Found IT8712F chip at 0x290, revision 7
> it87: in3 is VCC (+5V)
> it87: in7 is VCCH (+5V Stand-By)
> ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
> [0x295-0x296]
> ACPI: Device needs an ACPI driver
> FATAL: Error inserting it87
> (/lib/modules/2.6.31/kernel/drivers/hwmon/it87.ko): Device or resource
> busy

Not a bug, see http://bugzilla.kernel.org/show_bug.cgi?id=13967
Add acpi_enforce_resources=lax to your kernel boot options.

-h


