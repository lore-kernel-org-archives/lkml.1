Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZGYAft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZGYAft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 20:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZGYAfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 20:35:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53419 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZGYAfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 20:35:48 -0400
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 0/2] ACPI 4.0 power meter
To: "Darrick J. Wong" <djwong@us.ibm.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>
Date: Fri, 24 Jul 2009 17:43:22 -0700
Message-ID: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a two-part patchset.  The first patch extends the hwmon sysfs interface
to include power capping features and extra data about the accuracy and
internal operation of the power meter.  The second patch implements a hwmon
driver for ACPI 4.0 compliant power meters that uses the expanded sysfs
interface.  I don't have an example DSDT from any actual piece of hardware, but
I can send some sample ASL code that I've been using to outfit kvm with a power
meter if anyone requests it.

(I suppose it could be integrated into the kernel source tree as some sort of
test case?)

--D
