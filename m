Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZGTDpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZGTDpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZGTDpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:45:21 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:61291 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZGTDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=smdWfiWP1lxqbOBlThN9aAxXIO+FGdK9VLRNqPAQDJjQzoPx6xy9QAx+dv2+KUy8Wy
         vzvX4Q+wKcsMt2gcQPaENIq3Fpm0V3r/jQAwwTU79fohV43wR7YSEgH74FPJYz+Sjxkr
         +aTpCFFnmxss07i+/4mIaBCab6AiD72C2SKGQ=
MIME-Version: 1.0
Date: Sun, 19 Jul 2009 20:45:20 -0700
Message-ID: <dd18b0c30907192045t3078451ao9af4c1751d9efe91@mail.gmail.com>
Subject: btusb_send_frame: hci0 urb ede00a50 submission failed
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure whats happening here,
this morning using s2ram worked like a charm,
now at the end of the day this thing takes a good minute to
wakeup. As for the blueooth finally got it working, but
now I'm seeing this in dmesg:


[  708.630722] Restarting tasks ... done.
[  708.910090] usb 5-1: USB disconnect, address 3
[  708.910262] btusb_send_frame: hci0 urb ede00a50 submission failed
[  709.330776] [drm] Loading R500 Microcode

Maybe suspend works better when cooler, but in anycase
the bluetooth works perfectly recovers from s2ram, scrollball
works as well(all with SELinux running too).


-- 
Justin P. Mattock
