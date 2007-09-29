Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXI2AzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXI2AzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbXI2Ay5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:54:57 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:53852 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbXI2Ay5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:54:57 -0400
Date: Sat, 29 Sep 2007 02:54:53 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: regression in 2.6.23-rc8 - power off failed
Message-ID: <20070929005453.GA4475@erig.dyndns.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Alexey Starikovskiy <astarikovskiy@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the latest kernel does not power off my system.

2.6.22 succeeded
2.6.23-rc8 failed

$ git bisect bad  
Bisecting: 0 revisions left to test after this 
[f216cc3748a3a22c2b99390fddcdafa0583791a2] ACPI: suspend: consolidate handling of Sx states.

Which more info is needed?

Wolfgang
