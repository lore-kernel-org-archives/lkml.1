Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZLSI77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZLSI77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 03:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZLSI76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 03:59:58 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:61183 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZLSI75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 03:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=IgWIiI0RPo/iq9YhL5D+XiQDpYv8Yr1V6KJcJCJTMSXpHygo+nksF+3MXtKxFsxgHa
         OjUvYk0XVI6FByr3D4EpVpJ/QxIdiwHfjaGp4fPyT0FAbg6nXrNMQhh0PAUniLIb3DYs
         UzvsySarKFok5JOAE5bQj2qhaMXtbzJwIPXgY=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 19 Dec 2009 00:59:36 -0800
Message-ID: <43e72e890912190059k3347887crfb7ded226c7a8d4b@mail.gmail.com>
Subject: Compat-wireless releases for 2.6.33-rc1 and 2.6.32.2
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-rc1 went out yesterday so today we get the respective backport
code now with 802.11 and bluetooth combined on the compat-wireless
package [1]. At this point only bug fixes are welcomed for that
package. At the last minute I decided to add Atheros Ethernet drivers
atlx, atl1e and atl1c. For wireless specific updates refer to wireless
2.6.33-rc1 ChangeLog [2]. If there are any bugs please report them
through linux-wireless. I've tested ath5k on 2.6.27.41 on x86_64 and
send this e-mail out through it. I should note
./scripts/drivers-select is busted as I never got a chance to update
it based on the latest changes.

While at it 2.6.32.2 got released today so I just updated a release
for that so users can benefit from the few fixes [3], you can check
the ChangeLog for that on the wireless for details on the changes [4].

For more details and sha1 checksums you can refer to the wireless wiki
compat-wireless stable page [5].

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/compat-wireless-2.6.33-rc1.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/ChangeLog-2.6.33-rc1-wireless
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.2.tar.bz2
[4] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32.2-wireless
[5] http://wireless.kernel.org/en/users/Download/stable

  Luis
