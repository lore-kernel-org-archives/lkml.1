Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0CCGZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:25:50 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:44514 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0CCGZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bfs9dUAE6HUSJbpGgwO7PoLczYE5Nk/LRUp0ChvAt8gl4E2M9kWa8CJtPbcc8J54Mz
         GHcdORpuXno5NTDGRR3vUrW85llI81bZ6jsAx7yJPoXqX/mfq75umpgAlCPc7Tpg55o9
         4EQCSilOjiFnwidn34dRL9X3t9k7oRFhqUfog=
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 14:25:48 +0800
Message-ID: <69c625271003022225l49eac2fdh932b934c0ca6f6e7@mail.gmail.com>
Subject: linux 2.6.32 and 2.6.26 nat with pppoe throughput is very different.
From: sung descent <descent0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,
I use debian to do NAT and use PPPoE for WAN side.
3 PCs, one for pppoe server, one for NAT+PPPoE  client (WAN), one for
normal used.

test direction:
pc -> debian(nat+pppoe (WAN)) -> pppoe server

I use iperf to test the throughput:

debian kernel | iperf throughput
2.6.26           | 180 Mbits/sec
2.6.32           | 48.7 Mbits/sec

iperf version: 2.0.2

Can I do any improvement to get better throughput?
