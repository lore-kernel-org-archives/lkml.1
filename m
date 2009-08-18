Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZHRDbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZHRDbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZHRDbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:31:49 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44210 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZHRDbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:31:49 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 23:31:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bg2YINt2zM/58fEGkAHOD9g5JZGa6VNXoawxeKO+QT0BVSiKz/B1GZf6K8aYhPLJ2F
         c8nrtRCZexhBXbZJ2qi3JiSb1c3PBwFxa9NqZU68Cw+60uR5JoAJiSYlq+xu2fsvx6we
         0vfxLG2KCF8qZRSj4jcCaHBBuCEQcNVkWlx98=
MIME-Version: 1.0
Date: Tue, 18 Aug 2009 11:25:22 +0800
Message-ID: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
Subject: -mm hang while shutdown with printk_delay
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Test with printk_delay=200,

/sbin/halt -p

kernel hang after following message:

Disabling non-boot CPUs

There's no such problem with 2.6.31-rc6
-- 
Regards
dave
