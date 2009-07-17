Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZGQTV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZGQTV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 15:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZGQTVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 15:21:55 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:54410 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZGQTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rwmR5SkhIcus6z7PKBAgLQaxXcONbnwaLzmVenGdrxjiexlNSftZEVILgoNG6q6Om0
         eETl+B3MXfx/elE8PW7d8yu0rff8SpWGxga9lM/pLsN123+u8KfpYtHepgffmN3wpT8I
         nQkwVQ4ym270CliASF3MPldUgD68/FbTJ0jH8=
Message-ID: <4A60CFF5.7030600@gmail.com>
Date: Fri, 17 Jul 2009 16:24:37 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090628)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: suspend script fails with 2.6.31, related to stdout?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a pm-suspend hook fails with 2.6.31 (which does not under 2.6.30). the 
error as follows:
---

/etc/pm/sleep.d/11netcfg resume suspend: /bin/stty: standard input: 
Inappropriate ioctl for device
/bin/stty: standard input: Inappropriate ioctl for device
:: Scanning for networks    [BUSY] wlan0     Interface doesn't support 
scanning : Network is down

wlan0     Interface doesn't support scanning : Network is down

wlan0     Interface doesn't support scanning : Network is down

wlan0     Interface doesn't support scanning : Network is down

wlan0     Interface doesn't support scanning : Network is down

wlan0     Interface doesn't support scanning : Network is down

/etc/rc.d/functions: line 99: printf: - : invalid option
printf: usage: printf [-v var] format [arguments]
   [FAIL]
---
ive been tracking down the script, and it all comes down to iwlist 
(which is used to scan for networks) which prints outputs to stdout. i 
dont know how to debug this any further.. does anyone have any idea?
