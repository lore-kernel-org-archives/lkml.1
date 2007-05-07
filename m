Return-Path: <linux-kernel-owner+w=401wt.eu-S966686AbXEGVGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966686AbXEGVGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966649AbXEGVGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:06:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:26137 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966660AbXEGVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rsfeIYDlCHjA+sAX6aG+yH+6J6OzOESh5vwtUsZqMqyBMHVi/elwKp0Ez9PLM1tZdNNNULobJjFivJi0HmcXM9tJ8AK2rPXeWPbhOB4/3YHDAO9g9XmUFWJktDQq+B6aKNakJVkIWewTPyZhHKdLknavJyWyOnvQkaonWvGEQBg=
Message-ID: <a44ae5cd0705071405x61f72efao706aeecbc02e772e@mail.gmail.com>
Date: Mon, 7 May 2007 14:05:59 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: 2.6.21-mm1+hotfix -- Lid button does not initiate a suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is on my HP Pavilion dv1240us laptop.
I know the events are generated correctly:
# killall acpid
# cat /proc/acpi/event
button/lid LID0 00000080 00000001 (Press #1)
button/lid LID0 00000080 00000002 (Release #1)
button/lid LID0 00000080 00000003 (Press #2)
button/lid LID0 00000080 00000004 (Release #2)
# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
PCIB      S5     disabled  pci:0000:00:1e.0
LAN       S5     disabled  pci:0000:01:00.0
PS2K      S3     disabled  pnp:00:05
PSM1      S3     disabled  pnp:00:06
USB0      S3     disabled  pci:0000:00:1d.0
USB1      S3     disabled  pci:0000:00:1d.1
USB2      S3     disabled  pci:0000:00:1d.2
USB7      S3     disabled  pci:0000:00:1d.7
