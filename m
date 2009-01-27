Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZA0HhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZA0HhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZA0HhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:37:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:46120 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZA0HhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:37:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=lYj6KKXrrW7r1WVx7ok0Q5vhcMo6O0tAwcVwFW4j9PTL39MpUAVbsQKwMLkMa/66KG
         4nED3KlawztMhO6IFK6/bxm0WB5e/bGKsFceMVAGSRl2U72UMf+dFw21BocHNnGtjmV1
         dcqPDvO8hHzbsOkcn92gAJ2MOOQkVN0qeVAOU=
Message-ID: <497EB99B.5030002@gmail.com>
Date: Mon, 26 Jan 2009 23:36:59 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ath9k authenticate log message
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using ath9k with my home wireless
network I normally would see this message:

[   31.376074] wlan0: authenticate with AP 00:80:c6:e8:a6:a1
[   31.390489] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[   31.395339] wlan0: authenticated
[   31.395343] wlan0: associate with AP 00:80:c6:e8:a5:cb
[   31.397740] wlan0: RX ReassocResp from 00:80:c6:e8:a5:cb (capab=0x1 
status=0 aid=10)
[   31.397744] wlan0: associated

once for the whole session.
Now running ath9k in a hotel room
(or public location); I see this message numerous
amounts of time (taken from dmesg);

[   44.372207] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[   44.379689] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[   44.381961] wlan0: authenticated
[   44.381967] wlan0: associate with AP 00:80:c6:e8:a5:cb
[   44.386192] wlan0: RX ReassocResp from 00:80:c6:e8:a5:cb (capab=0x1 
status=0 aid=10)
[   44.386198] wlan0: associated
[   84.376070] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[   84.390277] wlan0: authenticate with AP 00:80:c6:e8:a6:a1
[   84.397780] wlan0: authenticate with AP 00:80:c6:e8:a6:a1
[   84.404905] wlan0: authenticated
[   84.404908] wlan0: associate with AP 00:80:c6:e8:a6:a1
[   84.408576] wlan0: RX ReassocResp from 00:80:c6:e8:a6:a1 (capab=0x1 
status=0 aid=13)
[   84.408579] wlan0: associated
[  144.393190] wlan0: direct probe to AP 00:80:c6:e8:a6:a1 try 1
[  144.400566] wlan0: direct probe to AP 00:80:c6:e8:a6:a1 try 1
[  144.405215] wlan0 direct probe responded
[  144.405221] wlan0: authenticate with AP 00:80:c6:e8:a6:a1
[  144.414515] wlan0: authenticated
[  144.414521] wlan0: associate with AP 00:80:c6:e8:a6:a1
[  144.417903] wlan0: RX ReassocResp from 00:80:c6:e8:a6:a1 (capab=0x1 
status=0 aid=13)
[  144.417910] wlan0: associated
[  224.386575] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[  224.389481] wlan0: authenticated
[  224.389488] wlan0: associate with AP 00:80:c6:e8:a5:cb
[  224.393146] wlan0: RX ReassocResp from 00:80:c6:e8:a5:cb (capab=0x1 
status=0 aid=10)
[  224.393152] wlan0: associated
[  804.406071] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[  804.420377] wlan0: authenticate with AP 00:80:c6:e8:a6:a1
[  804.425810] wlan0: authenticated
[  804.425817] wlan0: associate with AP 00:80:c6:e8:a6:a1
[  804.429649] wlan0: RX ReassocResp from 00:80:c6:e8:a6:a1 (capab=0x1 
status=0 aid=13)
[  804.429655] wlan0: associated
[  924.416909] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[  924.419635] wlan0: authenticated
[  924.419640] wlan0: associate with AP 00:80:c6:e8:a5:cb
[  924.423096] wlan0: RX ReassocResp from 00:80:c6:e8:a5:cb (capab=0x1 
status=0 aid=10)
[  924.423102] wlan0: associated
[ 2484.466823] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[ 2484.481143] wlan0: authenticate with AP 00:80:c6:e8:a6:a1
[ 2484.483545] wlan0: authenticated
[ 2484.483551] wlan0: associate with AP 00:80:c6:e8:a6:a1
[ 2484.680115] wlan0: RX ReassocResp from 00:80:c6:e8:a6:a1 (capab=0x1 
status=0 aid=13)
[ 2484.680122] wlan0: associated
[ 2604.486887] wlan0: authenticate with AP 00:80:c6:e8:a5:cb
[ 2604.491285] wlan0: authenticated
[ 2604.491291] wlan0: associate with AP 00:80:c6:e8:a5:cb
[ 2604.690069] wlan0: associate with AP 00:80:c6:e8:a5:cb


As for any connection issues(after adjusting sysctl.conf)
and adding: options wlan0 disable_hw_scan=1
to /etc/modprobe.d/options.
haven't experienced any issues(so far at least);

In any case; is this normal for public wifi
(since there is no key), or is this something
easily fixed by adjusting my .config?

regards;

Justin P. Mattock



