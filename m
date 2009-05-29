Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZE2S5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZE2S5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZE2S5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:57:12 -0400
Received: from mail.pentek.com ([12.35.250.145]:3144 "HELO mailhost.pentek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753213AbZE2S5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:57:11 -0400
Message-ID: <4A202FF3.2090600@pentek.com>
Date: Fri, 29 May 2009 14:56:51 -0400
From: Steve Rottinger <steve@pentek.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: O_DIRECT splice from PCI-resident buffer to filesystem
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After some work, and kernel hacking, and thanks to Jens'
O_DIRECT/blockio splicing
patch,  I have been successful in using splice to transfer data directly
from a buffer
resident on a PCI device to a raw disk partition, with zero copies. Great!
Can anyone tell me if it is feasible to transfer data in the same way,
using splice
to a file, on a filesystem, instead of a raw block device with zero
copies?   Looking at
the code, it appears that the data is copied using memcpy, no matter what.

Thanks,

-Steve

