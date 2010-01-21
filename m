Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226Ab0AULKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0AULKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060Ab0AULKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:10:15 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60907 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0AULKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=SEpELwaHktSTyZ4r6TSRRw/4IATv7hnXk8iUTs4cpUA0JoLJvUtCL4Yzqp7DQPRCrJ
         uIitva7nRXx0aoY1AwQrjZE08oXxhuP8kCD0llDQ2cwsPrjyfwB4tjbtRMc/QC4vxZb3
         4P9EbbnAXKBvg5NknOh7m5LomLMbr8WJVVvug=
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 12:10:12 +0100
X-Google-Sender-Auth: 09fe239b5af3b195
Message-ID: <ff13bc9a1001210310x5ebc9993kbf6b302285d2d9a4@mail.gmail.com>
Subject: perf record -g hangs the system
From: Luca Barbieri <luca@luca-barbieri.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experiencing a system lockup running the following command:
perf record -g true

The system hangs and does not respond to any sysrq.
No messages are printed to netconsole.

This is with 2.6.33-rc4 on an x86-32 Core 2 dual core machine.

Any tips on how to debug/fix this?
