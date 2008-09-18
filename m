Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYIRFmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYIRFmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 01:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYIRFmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 01:42:39 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:40377 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845AbYIRFmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 01:42:38 -0400
X-AuditID: ac189297-acf85bb000000fe5-85-48d1f8361ed2
Message-ID: <48D1EA22.2040709@alcatel-lucent.com>
Date: Thu, 18 Sep 2008 13:41:54 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: change TOS explicitly for egress packets on specified network interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2008 05:41:54.0472 (UTC) FILETIME=[41DB8280:01C91951]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I want to control TOS for egress packets of specified network interface, 
so I introduced "unsigned long tos" to
struct net_device::priv and it could be set through ioctl interface of 
ethernet driver.

But I don't know where to change TOS for egress packets because:
1) It seems TOS is used for route select now;
2) struct inet_sock has already included one "tos" field inside and it 
couldn't be set inside ethernet driver;

Thanks,
Gavin
