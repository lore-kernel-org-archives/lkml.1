Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCKKl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCKKl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZCKKls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:41:48 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:41144 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZCKKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=imL5CEw3UEYcIGAKNblCpKKz00eNud0QIYMg2ZxI/E6swfQi6QQWJlIfv/iY8V6MlJ
         5V3y4hmMxlHsIhXpfJ/mDyxp1Si1l0RtZdyK35N0rq8wp0HXCOApd8deXh+xTULTUrJZ
         iLpR+a74KAKzVOnytMnDpIroSfVFDcYC0E9tM=
MIME-Version: 1.0
Date: Wed, 11 Mar 2009 11:41:43 +0100
Message-ID: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
Subject: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a box where the oom-killer is killing processes due to running
out of memory in zone_normal. I can see using slabtop that the inode
caches are using up lots of memory and guess this is the problem, so
have cleared them using an echo to drop_caches.

I would quite like to not guess though - is it possible to use slabtop
(or any other way) to view ram usage per zone so I can pick out the
culprit?

(I am not subscribed to the list, please cc any replies to me.)

Thanks a lot.

p.s. the kernel traffic link on http://www.tux.org/lkml/ is now a spam site
