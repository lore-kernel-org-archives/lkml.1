Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbXIZSgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbXIZSgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbXIZSgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:36:03 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60586 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbXIZSgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:36:01 -0400
Message-ID: <46FAA68E.1020306@tiscali.nl>
Date: Wed, 26 Sep 2007 20:35:58 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: forcedeth question
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in file ./drivers/net/forcedeth.c
line 2142 of current git I have a
for (i=0;i<=np->register_size;i+= 32) {
           ^
shouldn't this be a '<'

In the same file on line 4015:
for (i = 0;i <= np->register_size/sizeof(u32); i++)

shouldn't the "<=" be a '<'?

Roel
