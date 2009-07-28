Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZG1B0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZG1B0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZG1B0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:26:07 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:48391 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZG1B0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:26:06 -0400
Date: Mon, 27 Jul 2009 21:25:54 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 2/2] acpi_power_meter: hwmon driver for ACPI 4.0 power
 meters
In-reply-to: <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com>
Message-id: <alpine.LFD.2.00.0907272124110.4445@localhost.localdomain>
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com>
 <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,
On the system you are planning to run this on...
Are the power meters in the processor, or elsewhere?

If they are the ones in the processor, I'd rather that
Linux use a native model-specific driver to access those
registers and not use ACPI.

thanks,
Len Brown, Intel Open Source Technology Center
