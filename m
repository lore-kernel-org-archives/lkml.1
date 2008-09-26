Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYIZWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYIZWP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYIZWPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:15:15 -0400
Received: from lirone.symas.net ([64.71.152.235]:43077 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYIZWPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:15:14 -0400
X-Greylist: delayed 2053 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 18:15:14 EDT
Message-ID: <48DD56E5.2080705@symas.com>
Date: Fri, 26 Sep 2008 14:40:53 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.1b1pre) Gecko/20080917130338 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: mjg@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: hp-wmi on HP dv5z
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, just got a new HP dv5z laptop and trying to make sense of how everything 
fits together. The wifi button on this laptop doesn't appear to generate any 
keyboard event. I loaded the hp-wmi module, and that allows me to toggle the 
wlan and bluetooth in software, by writing to 
/sys/class/rfkill/rfkill[01]/state. But pressing the button still does 
nothing. What am I missing?

Also, disabling the wifi the first time turns the wifi LED from blue (active) 
to orange (inactive) which is what I'd expect, but re-enabling it leaves the 
LED orange. Again, what am I missing?

Without the hp-wmi module loaded, FN+F7 and FN+F8 would control the display 
backlight brightness. With it loaded, these keys do nothing. Seems there's 
some conflict between hp-wmi and ACPI. Any suggestions?
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
