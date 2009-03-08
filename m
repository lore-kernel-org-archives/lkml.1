Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZCHXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZCHXOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZCHXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:13:56 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:40423 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZCHXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:13:56 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Mar 2009 19:13:55 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=DtlaEL1/FokEjl13k79VBGNTOUDWjQc+eJE6P/l7ry91mts0Fvq7E4zeZ6M20Jt6JL
         xcB4lw/g/mbXUQq/BFGPZJC2Jw5mefKZLNB55kwe6o581C+F4PsSO6WX3uFzJvLhy72Y
         bax46FiROrLXLjQqSZCUiDMgEkZ2levNlEMwQ=
MIME-Version: 1.0
Date: Sun, 8 Mar 2009 23:07:57 +0000
Message-ID: <6c046ab30903081607n5a724ff6l4a47218ffa255f5@mail.gmail.com>
Subject: acer-wmi, intel wifilink 5300 rf-kill regression with kernels > 
	2.6.27
From: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an acer laptop with an intel 5300 wifi link card. The rf-kill
toggle switch works flawlessly with 2.6.27.

In 2.6.28 and 2.6.29rc7 with acer-wmi loaded The LED starts on, the /
sys/bus/.../rfkill*/state is 1 but the kernel believes the card is
disabled. Toggling the switch once turns the LED off, and the state to
2, and the kernel still thinks the rf-kill switch is on. Finally
further toggling the switch does not change it ; it remains stuck at
state 2.

modprobe -r acer_wmi instantly solves the issue, and appears to be the
only usable workaround.
