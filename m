Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZFYHFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZFYHFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFYHE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:04:56 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:52111 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbZFYHEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:04:55 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Date: Thu, 25 Jun 2009 09:04:56 +0200
User-Agent: KMail/1.9.9
Cc: dm-devel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906250904.57149.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jun 2009 07:04:57.0942 (UTC) FILETIME=[3FE6AF60:01C9F563]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot of 2.6.31-rc1 on an arm EABI system I got the following errors:

device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
device-mapper: table: 254:0: target device sda6 is misaligned
device-mapper: table: 254:0: target device sda6 is misaligned
device-mapper: table: 254:1: target device sda6 is misaligned
device-mapper: table: 254:1: target device sda6 is misaligned

The boot did complete successfully. A boot with 2.6.30 just previously was
clean, and when I reboot back into 2.6.30 the messages are gone again.

The system has a single volume group with two logical volumes.

Please advise and let me know what additional info is needed.

Cheers,
FJP
