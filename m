Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZHCU6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZHCU6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZHCU6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:58:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42461 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZHCU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:58:32 -0400
Date: Mon, 3 Aug 2009 13:58:12 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 2/2] acpi_power_meter: hwmon driver for ACPI 4.0 power
	meters
Message-ID: <20090803205812.GC14694@plum>
Reply-To: djwong@us.ibm.com
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com> <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com> <alpine.LFD.2.00.0907272124110.4445@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907272124110.4445@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:25:54PM -0400, Len Brown wrote:
> Hi Darrick,
> On the system you are planning to run this on...
> Are the power meters in the processor, or elsewhere?
> 
> If they are the ones in the processor, I'd rather that
> Linux use a native model-specific driver to access those
> registers and not use ACPI.

They're not in the processor.  Right now we're simulating the meters in kvm
until we get real hardware, though it could be a mechanism to report per-VM
power use.

--D
