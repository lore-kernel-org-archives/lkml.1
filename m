Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZKJCiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZKJCiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZKJCiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:38:14 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:60929 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZKJCiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:38:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FPO0Lj9Q9fq1Qxp59FNsaR38tJZjA9U5sorp88F/Nwnfzz4yNvSHlfj9JhqKGB45Ss
         Cpjgifjhy7V4btdAGAUvIxxh/+J2k4lD1tv+GTUGeCWB54Vaz90qcMQnQkOBTX/HaamE
         xyuuKNysenwNa8RjrPeLp1sFOxXGy4zAP9nnc=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, zaurus-devel@www.linuxtogo.org
Subject: [RFC PATCH 0/2] power: implement platform battery driver
Date: Tue, 10 Nov 2009 05:37:51 +0300
Message-Id: <1257820673-30801-1-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a simple generic implementation of a battery driver that
essentially gets all the information from platform-specific functions.

Tested on openmoko gta02 device but it looks like it can be useful for
other targets as well.

With such a simple driver it's quite easy for almost anybody to have an
opinion about an ideal implementation so come on, do not hesistate, i
really need your constructive feedback ;) One of the most obvious points is
the clumsy way to match entries in the properties arrays with the
callbacks. I did so to avoid an extra alloc + copy stuff but if you battery
guys find this really unacceptable, well, i'll do it the way you like :)

Pavel, i saw you posting spitz battery driver and thought you might find
this useful.

[RFC PATCH 1/2] power: implement platform battery driver
[RFC PATCH 2/2] gta02: add support for platform_battery
