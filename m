Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZIKPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZIKPMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZIKPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:12:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:7147 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZIKPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Cp23GVGWc7WqJjOsI9VPP8j9/OWknve3xdDzExu3mIeMJgXpAaM7aWh+Lqq2OkMRZM
         76K6ch478MMuszNhroO/f1hDgov5vAaKvC2UhXXMDYfgAkI2460HeSj0ulPhARpVTEhv
         9G2PEbfckgBZ63cNiVPYdZ8D40iWjaBX8hhVs=
MIME-Version: 1.0
Date: Fri, 11 Sep 2009 10:12:32 -0500
Message-ID: <84fb38e30909110812r23ed0db0y80ae17178395694e@mail.gmail.com>
Subject: sony-laptop platform driver
From: tsuraan <tsuraan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current mainline sony-laptop platform driver is missing some
crucial features from Eva's driver
(http://www.basyskom.org/~eva/log_installation_vaio_z21vnx.html),
especially the ability to shut off the embedded nvidia card in laptops
with hybrid graphics.  Simply disabling the nvidia card using Eva's
driver brings my laptop's power consumption from 18W to 12W, which is
a pretty huge leap in battery life.

Is there any plan to merge the changes from Eva's driver into
mainline?  Eva's current 0.9 driver wont compile under 2.6.31 due to a
pretty major reorganization of the mainline code, so I'm stuck with
2.6.30 until either the nvidia disabling code is merged into mainline,
or Eva's driver gets updated.  I would think a merge would be ideal,
if it's possible.
