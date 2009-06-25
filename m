Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZFYDmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZFYDmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZFYDlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:41:53 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:62899 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZFYDlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:41:53 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2009 23:41:53 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=v1Tw7PhV8Q5BuLUsaMO1LVGlq0SWXQwbBZeKOK6SAzleGGTihbTX7Th2wskaThxkXM
         wrzDslO4rzwXf2PVTcChbt5mEbiL7tXhdjYYoVotkrDWKo1/vWVGP4sclQuyq4uH2c7n
         MXI0cO0KJlcdyr2C8AzDacVUfvbgDToqzE/0A=
MIME-Version: 1.0
Date: Thu, 25 Jun 2009 11:33:38 +0800
Message-ID: <113d36d80906242033p134edf27t12bda1d0359c4134@mail.gmail.com>
Subject: question on A2DP sink suspend/resume
From: lan zhu <zhu.lan.cn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to create SCO link when A2DP is in streaming state, we
shall suspend A2DP first and then establish SCO link. Conversely, we
shall resume A2DP link when we drop SCO link. The entire description
can be found in the Simultaneous use of HFP, A2DP, and AVRCP Profiles
Whitepaper on bluetooth org web site.
(https://www.bluetooth.org/Technical/Specifications/whitepapers.htm).

My question is,  I found there is no such sink_suspend or sink_resume
method in D-BUS API while these functions are all implemented in Bluez
audio module. I would like to know why don't put them to D-BUS API?
If we need to call these functions we have to expand the D-BUS API.

One more question is, is there a formal way to test SCO/A2DP
simultaneous case? we can't find a proper headset to test it because
those headsets are all well implemented with the simultaneous logic,
so there is no way to enter ourselves' code that handle this logic.
Can we test it by configurating some test tool such as PTS?


 Thanks,
 Zhu Lan
