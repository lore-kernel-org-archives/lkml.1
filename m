Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYKZIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYKZIwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYKZIru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:47:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:55273 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYKZIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding:from;
        b=tIuOCqR486+UmisvDKXWfCC8k2OhdtDbvmBVWWPoZx0xx09tskqTr38sIvExEM4iaO
         js7h9+KwPf9XY8+TD1Fa3MC7RigZdhn/HN5Sc3Nfu/hWA+ulR5VJ/i9Y2YgzXS45znxN
         5XKhKwJ36kkXdE/ac5DQM1nz6xhcIaBXTSkfI=
Subject: [RE:] pull request: wireless-2.6 2008-11-25
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SE Linux <selinux@tycho.nsa.gov>, tresys <refpolicy@oss.tresys.com>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 00:47:43 -0800
Message-Id: <1227689263.3145.14.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
From: "Justin P. Mattock" <justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apologize for not sending the original post
(accidentally removed it);
from the post:
http://lkml.org/lkml/2008/11/25/353
I take it this is the reason for the avc's that are being created,
and always denied: <example>


-- [   26.659175] type=1400 audit(1227658649.652:3): avc:  denied
{ sys_module } for  pid=2631 comm="wpa_supplicant" capability=16
scontext=system_u:system_r:system_dbusd_t:s0
tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
[   26.659351] type=1300 audit(1227658649.652:3): arch=40000003
syscall=54 success=no exit=-19 a0=9 a1=8933 a2=bfb6ff9c a3=bfb6ff9c
items=0 ppid=1 pid=2631 auid=4294967295 uid=0 gid=0 euid=0 suid=0
fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295
comm="wpa_supplicant" exe="/sbin/wpa_supplicant"
subj=system_u:system_r:system_dbusd_t:s0 key=(null)
[   30.131444] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   30.140774] input: justinmattocks mouse #1 as /class/input/input10
[   30.194328] generic-bluetooth 0005:0000:0000.0004: input: BLUETOOTH
HID v0.00 Mouse [justinmattocks mouse #1] on 00:17:F2:B4:BC:F5
[   33.361691] [drm] Setting GART location based on new memory map
[   33.363216] [drm] Loading R500 Microcode
[   33.363295] [drm] Num pipes: 1
[   33.363309] [drm] writeback test succeeded in 1 usecs
[   84.658454] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[   84.664222] wlan0: authenticated
[   84.664230] wlan0: associate with AP 00:1e:2a:00:67:f0
[   84.666704] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431
status=0 aid=34)
[   84.666710] wlan0: associated
[   92.657555] type=1400 audit(1227658715.650:4): avc:  denied
{ sys_admin } for  pid=3042 comm="mount" capability=21
scontext=system_u:system_r:system_dbusd_t:s0
tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
[   92.657594] type=1300 audit(1227658715.650:4): arch=40000003
syscall=21 success=no exit=-1 a0=8061818 a1=8061828 a2=805a521
a3=c0ed1000 items=0 ppid=3033 pid=3042 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295
comm="mount" exe="/bin/mount" subj=system_u:system_r:system_dbusd_t:s0
key=(null)
[   92.661764] type=1400 audit(1227658715.660:5): avc:  denied
{ sys_admin } for  pid=3044 comm="mount" capability=21
scontext=system_u:system_r:system_dbusd_t:s0
tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
[   92.661820] type=1300 audit(1227658715.660:5): arch=40000003
syscall=21 success=no exit=-1 a0=8061818 a1=8061828 a2=805a521
a3=c0ed1000 items=0 ppid=3033 pid=3044 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295
comm="mount" exe="/bin/mount" subj=system_u:system_r:system_dbusd_t:s0
key=(null)

allow rules are as is:

 #============= system_dbusd_t ==============
allow system_dbusd_t self:capability { sys_module sys_admin };

I do have debug enabled for ath9k;
I'll look at the policy(once the wireless is committed)
to see if this was the resulting... and/or happening.

regards;


Justin P. Mattock <Justinmattock@gmail.com>

