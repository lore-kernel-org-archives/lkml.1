Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZDHDhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZDHDhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZDHDh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:37:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:61829 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZDHDh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:37:28 -0400
Message-Id: <6F1ECC5B-A247-4328-892E-1620FF5E2172@mirell.org>
From: Mark Miller <mark@mirell.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Versatile PB Board Support for ARMv6 and ARMv7
Date: Tue, 7 Apr 2009 22:37:25 -0500
Cc: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       qemu-devel@nongnu.org
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Apologies if this appeared twice for some. My mail client was  
misbehaving and sending HTML messages)

In late October 2008, according to the git logs, the methodology for  
selecting a processor on several boards, at least the Versatile PB  
board was changed so that it automatically selects CPU_ARM926T as a  
hidden symbol.

The reason I have a question, is since QEMU currently can emulate a  
Versatile PB board with other processors than just the ARM926T (Such  
as the ARM1136 (ARMv6) and Cortex-A8 (ARMv7), is there a good way to  
allow that in the mainstream kernel? Previously the patch was to just  
add extra potential dependencies on CPU_V6 and CPU_V7, so that by  
selecting MACH_VERSATILE_PB, you could select ARMv6/v7 support.

Currently I'm just deleting the select statement, and having all the  
CPUs appear, as no longer hidden symbols. My question is, what is the  
best way to allow for other processors for this board in Kconfig, so  
it could be submitted to the mainstream kernel?

-- 
Mark A. Miller
mark@mirell.org



