Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZAHDr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZAHDr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZAHDrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:47:49 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:62316 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZAHDrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=g65lOoIimxGuGQThmBcvueRE7+pArcW6o3HlV2CjYgg0SiT7urVLqjsEqi2wVkAyVz
         8Er/wzePQqduDN6RwqFQ34OEsd7rkyfhoaEuQ8SOB39csFiL4xteTuM6suL/jI2CdJtz
         g9HJEqjDCWyfmNDlyVplTdc1wr2oNWWz/bOfE=
Message-ID: <da8464b10901071947v3e2b156dj9692ead8d6a35e6f@mail.gmail.com>
Date: Thu, 8 Jan 2009 11:47:46 +0800
From: "Wang Xu" <gnawux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: "Treason uncloaked" issue of TCP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a cluster with around 200 nodes, and all of them are installed
with CentOS 5.2/2.6.18-92.el5 kernel.
And we found many dmesg log as follows:
 | TCP: Treason uncloaked! Peer 192.168.33.182:55510/60222 shrinks
window 977590224:977590304. Repaired.
 | TCP: Treason uncloaked! Peer 192.168.33.185:55510/49646 shrinks
window 2483808366:2483808382. Repaired.
 | TCP: Treason uncloaked! Peer 192.168.33.133:51316/51560 shrinks
window 236559458:236559498. Repaired.
 | TCP: Treason uncloaked! Peer 192.168.33.115:55510/53342 shrinks
window 3977841758:3977841854. Repaired.

I searched from the web but cannot get any idea:
 * its a cluster in lab, no WAN access and only with internal
communication, thus it shouldn't be something like attack.
 * all of them are linux (red hat/centos kernel), hence it must not be
other buggy stack
 * I have checked the source, and it have already with the patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ad41065d9fe518759b695fc2640cf9c07261dd2

Does anyone have some suggestion? And if you need any more
information, I can provide it.

Thank you!

-- 
Wang Xu
Timothy Leary  - "Women who seek to be equal with men lack ambition."
