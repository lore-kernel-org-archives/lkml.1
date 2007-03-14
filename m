Return-Path: <linux-kernel-owner+w=401wt.eu-S933865AbXCNFhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865AbXCNFhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCNFhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:37:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:50154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933833AbXCNFhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:37:39 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mathieu =?iso-8859-1?q?B=E9rard?= <Mathieu.Berard@crans.org>
Subject: Re: Regression between 2.6.20 and 2.6.21-rc1: NCQ problem with ahci and Hitachi drive
Date: Wed, 14 Mar 2007 01:31:28 -0400
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
References: <45EB6980.90600@crans.org> <45EB79C1.3070107@gmail.com> <45EC8B3E.7040706@crans.org>
In-Reply-To: <45EC8B3E.7040706@crans.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703140131.28251.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes It works with acpi=off (2.6.21-rc1):
> Please notice that IRQ is changed from 19 with ACPI to 11 without.

Please verify the problem still exists in the latest 2.6.21 git.

If yes, please file a bug here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

For 2.6.20.stable, please attach
the complete output from dmesg -s64000
output from acpidump
output from lspci -vv
and paste a copy of /proc/interrupts

For 2.6.21.broken, please attach as much
of the dmesg as you can capture, and the /proc/interrupts
if you can get that far.

thanks,
-Len
