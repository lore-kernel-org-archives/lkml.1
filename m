Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZERUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZERUxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZERUx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:53:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57353 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbZERUx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:53:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/2] PCI PM: Two patches for 2.6.31
Date: Mon, 18 May 2009 22:46:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905182246.41129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches change the behavior of pci_raw_set_power_state()
slightly to make if follow the PCI PM specification [1/2] and to prevent it
from setting current_state in a wrong way [2/2].

Please consider for applying.

Best,
Rafael

