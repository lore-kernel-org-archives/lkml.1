Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXHSTOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXHSTOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXHSTN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:13:59 -0400
Received: from web38907.mail.mud.yahoo.com ([209.191.125.113]:28941 "HELO
	web38907.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbXHSTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:13:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5vZfKAykNfKMjbcaaJ27oeuzFk4L5IZDmI+oU+nhUwZ5q6AEJyhsvOR8gmyQ07/nDmwwORPsb//yxGBms+b8ldlfrqGVgUm2UXbyncVPazl5qMIYTZwRiIHZPYyIVMgstCJn+PGU4/p7pw44mynVrWhoDwAFG4kbtMvEFjpypUU=;
X-YMail-OSG: MMlT7RwVM1n0icuzG1fJQVnjYUpmERinwkTITPLLvGCDNv8shaHHDR8Nt49uLazbJgLUTz2y4yTOxj48hs5FakHnHaptpKhjir4fCiAmOBRyletbo2BBF4iXo8SPRA--
Date: Sun, 19 Aug 2007 12:13:57 -0700 (PDT)
From: Kevin E <kevin360@yahoo.com>
Subject: Re: Marvell 88E8056 gigabit ethernet controller
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070819113400.12f5570c@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <551158.43737.qm@web38907.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> The driver prints some chip version info at startup,
> that might
> be helpful in disambiguating good/bad versions:
> 
> 	dmesg | grep sky2

Here's the output from the working MB:

sky2 0000:04:00.0: v1.14 addr 0xf8000000 irq 16
Yukon-EC Ultra (0xb4) rev 3
sky2 eth0: addr 00:1a:4d:42:61:46
sky2 eth0: enabling interface
sky2 eth0: ram buffer 0K
sky2 eth0: Link is up at 100 Mbps, full duplex, flow
control both

The broken MB there's no output in dmesg but there is
in /var/log/messages (I just rebooted the machine to
get the output):

Aug 19 14:56:42 www kernel: sky2 0000:04:00.0: v1.14
addr 0xf8000000 irq 16 Yukon-EC Ultra (0xb4) rev 3
Aug 19 14:56:42 www kernel: sky2 eth1: addr
00:1a:4d:82:11:02




       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
