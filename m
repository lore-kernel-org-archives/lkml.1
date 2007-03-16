Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXCPFBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXCPFBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 01:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXCPFBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 01:01:22 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:37366 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbXCPFBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 01:01:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPAPLA+UVKhRO4UGdsb2JhbACBZ4VMh1wBASo
From: Dmitry Torokhov <dtor@insightbb.com>
To: Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH] Improve error recovery in serial mouse driver
Date: Fri, 16 Mar 2007 01:01:19 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <m3k5xiqput.fsf@telia.com>
In-Reply-To: <m3k5xiqput.fsf@telia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703160101.20188.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 March 2007 15:16, Peter Osterlund wrote:
> If bytes get lost in the communication with a serial mouse using the
> MS protocol, the kernel driver could do a better job getting back in
> sync. The first byte in a packet has bit 6 set, and no other bytes
> have that bit set. Therefore, if a byte is received with bit 6 cleared
> when the driver thinks it is at byte 0 in the packet, the driver thinks
> wrong and the byte should just be ignored.
> 
> This fix prevents spurious left/right button events when the serial
> communication is disturbed by a CPU-hungry real-time process.
> 
> Signed-off-by: Peter Osterlund <petero2@telia.com>

Applied, thank you Peter.

-- 
Dmitry
