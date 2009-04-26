Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZDZNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZDZNhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZDZNhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:37:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33454 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZDZNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ec/OPem0yykO6EUJ1N2up7toUjvBRBOzKfwFGI0shlSWQ0o7aXdEcopdJ5L4u6IIo7
         tkaIALq3ErhacrYd0PgGs5LS0zWvjqA+5PVkVbwA+lP3VZ3JPO46j1zDv1RPClnkvnOL
         eiqeuMyX5Vp5b9AIsHBAMsFzkiXbyOR2CBdfE=
Subject: [BUG] /sys/class/power_supply/BAT0/ shouldn't disappear when
 battery is unplugged
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 26 Apr 2009 16:36:58 +0300
Message-Id: <1240753018.26851.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New sysfs battery interface has a flaw.

Suppose I removed battery from the system, and then booted it.
then gnome power manager has no idea that my system has battery, and
thus it hides battery settings.

It also has a bug that prevents it from hiding battery icon, when I
unplug the battery, in other words, it isn't prepared for battery to
disappear.

I think it would be nice to keep /sys/class/power_supply/BAT0/ even if
battery isn't present.

btw, there is /sys/class/power_supply/BAT0/present, thus maybe this is
just a bug?

Best regards,
	Maxim Levitsky

