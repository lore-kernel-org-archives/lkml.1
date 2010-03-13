Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab0CMSNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 13:13:41 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:4931 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953Ab0CMSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 13:13:38 -0500
Subject: [PATCH v2 0/3] ipmi: discovery precedence and update core driver with
	dev_printk
To: minyard@acm.org
From: Myron Stowe <myron.stowe@hp.com>
Cc: yakui.zhao@intel.com, linux-acpi@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Date: Sat, 13 Mar 2010 11:13:37 -0700
Message-ID: <20100313180121.20614.92547.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change the precedence of PNP based discovery mechanisms
and update the driver's core to use dev_printk() and its constructs.

As part of this patch series I wanted to remove the 'PFX' argument from
ipmi_of_probe()'s dev_printk constructs as I believe it produces redundant
output but I do not have a PPC platform to test against.


---

v2 - I dropped the contentious attempt to remove the ACPI SPMI static
     table as a discovery mechanism.

Myron Stowe (3):
      ipmi: Raise precedence of PNP based discovery mechanisms (ACPI, PCI)
      ipmi: Convert tracking of the ACPI device pointer to a PNP device
      ipmi: Update driver to use 'dev_printk()' and its constructs


Corey: If you encounter any issues applying this series let me know,
       including your current basis, and I'll re-work the series.


 drivers/char/ipmi/ipmi_msghandler.c |   11 +-
 drivers/char/ipmi/ipmi_si_intf.c    |  205 ++++++++++++++++-------------------
 2 files changed, 96 insertions(+), 120 deletions(-)

