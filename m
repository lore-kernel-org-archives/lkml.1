Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXIXMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXIXMd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXIXMdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:33:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:38886 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXIXMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BAUlo1rGBuZj7q3CnRvupndAwJBt+XDtMRf1GnwCJtbJIMrzlFdOij8B8XOI9VL9m2gYv2md9VbnfZ3rQy2uIY34KfJnGBUUx8q+qkZUVLfbZeT+e3bfOM3x4THbx7GtqVUfuwqeBJPrJ+LlXHWNROOLZ8YRIw5dK5NHCLTlfYw=
Message-ID: <46F7AEA7.7060809@gmail.com>
Date: Mon, 24 Sep 2007 14:33:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 11:17 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/

Fine, but on some boots (I noticed this on rc6-mm1 too, but not before):
0000:00:1a.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001

# lspci -vns 0000:00:1a.7
00:1a.7 0c03: 8086:293c (rev 02) (prog-if 20 [EHCI])
        Subsystem: 8086:293c
        Flags: bus master, medium devsel, latency 0, IRQ 19
        Memory at ffa7b400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port
        Capabilities: [98] Vendor Specific Information

# lspci -vns 0000:00:1d.7
00:1d.7 0c03: 8086:293a (rev 02) (prog-if 20 [EHCI])
        Subsystem: 8086:293a
        Flags: bus master, medium devsel, latency 0, IRQ 23
        Memory at ffa7b000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port
        Capabilities: [98] Vendor Specific Information

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
