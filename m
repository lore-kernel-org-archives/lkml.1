Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZKWRmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZKWRmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZKWRmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:42:13 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:47576 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZKWRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:42:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=UlW4WEXIhV7l5qbKOtYwe7yJL/MjrTAjCgU0qOk7HjWt5ECN0IGaAwdw7xyFuLrL7t
         gCBGmO2uNEAt2NpzgcrN1h99yL5MZylwlKzjlmuuyPG6DcmAoM8ZezwNRvBqtPZIaIBS
         6ML7+4DJ2SSDYQVRvfG7lqCd6oEU0vZo8SbAo=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Nov 2009 09:41:56 -0800
Message-ID: <43e72e890911230941m29394bcapcff95de9391637a3@mail.gmail.com>
Subject: Where to report firmware bugs
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Samir Gadkari <Samir.Gadkari@atheros.com>,
       Vikram Kandukuri <Vikram.Kandukuri@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have open firmware for at least one wireless device upstream,
the ar9170 device firmware [1]. Granted no specific point releases
have been made yet but it should be possible in the future to do so.
I'd also like to see more open firmware in the future. I also just
reviewed some simple driver for our bluetooth devices, the ath3k
driver and it seems clear to me in these cases that firmware will do
everything and chances are the actual driver won't have much bugs.

So -- for the cases of open firmware, or in cases where we have
firmware where it does most of the job of supporting the device where
should we send users to report bugs to? The kernel bugzilla at least
does not seem to have a section for firmware? Should it?

In the case of iwl3945 it seems users report bugs directly on the
kernel.org and refer the driver directly, we'll follow that for now,
but for cases where the firmware *is* the issue it would seem easier
to be able to search for issues specifically for firmware.

Thoughts?

[1] http://wireless.kernel.org/en/users/Drivers/ar9170.fw
[2] http://bugzilla.kernel.org/show_bug.cgi?id=13799

  Luis
