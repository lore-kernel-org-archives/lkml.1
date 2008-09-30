Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYI3T4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYI3T4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYI3Tzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:55:54 -0400
Received: from lirone.symas.net ([64.71.152.235]:45462 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYI3Tzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:55:53 -0400
Message-ID: <48E28443.7060708@symas.com>
Date: Tue, 30 Sep 2008 12:55:47 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.1b1pre) Gecko/20080917130338 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: APIC frequency too slow on HP dv5z
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More often than not, on a warm boot I see something like this

msg.new:[    1.940031] Using local APIC timer interrupts.
msg.new:[    1.944031] APIC timer calibration result 466046
msg.new:[    1.944031] Detected 0.466 MHz APIC timer.
msg.new:[    1.944031] APIC frequency too slow, disabling apic timer

On cold boots it may see 12.5MHz, or may not...

[    2.000584] Using local APIC timer interrupts.
[    2.004067] APIC timer calibration result 12500236
[    2.004080] Detected 12.500 MHz APIC timer.

I haven't figured out yet what the pattern is behind the behavior. Has anyone 
else seen this kind of problem before?
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
