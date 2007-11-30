Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbXK3XGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbXK3XGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbXK3XGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:06:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:44095 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332AbXK3XGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=TPs0tpaDATiTuf3pFL4vrZlvQJDnW0NPzlTee0RltqW3Znv0ztWfdi/bv9DyKDhjLfj56gKr6mHQEQqjxSND9U2qsOz3vhqUVBnpjq1/Mpv5Jw1pdw0zitTOP6kpzRdfTh6Uwn4ayibqerWfriWSVV+DCuDgs6Qi9/WPhDbtfRk=
Message-ID: <2c0942db0711301506k7e154b76kc1fc99c189f68a3d@mail.gmail.com>
Date: Fri, 30 Nov 2007 15:06:32 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: SoftMAC: Getting essid from req_essid
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 00b77d19d8c9d82e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey there Larry, all,

git blame fingered commit id efe870f9 (from Larry) for adding a couple
of fairly harmless looking messages to
net/ieee80211/softmac/ieee80211softmac_wx.c . The problem is that one
of them is clogging up my syslog at the tune of once a second or so
("SoftMAC: Getting essid from req_essid"), and rolling everything else
out of my dmesg.

I just rebooted into 2.6.23-rc3+some, and after 36 minutes of uptime I
already have:

$ dmesg | cut -d ']' -f2- | sort | uniq -c | sort -nr | head -3

   1047  SoftMAC: Getting essid from req_essid
     38  SoftMAC: Getting essid from associate_essid
     22  SoftMAC: Scanning finished: scanned 13 channels starting with channel 1

Is the message important for debugging, or can I make a patch to yank
the silly thing?

Ray
