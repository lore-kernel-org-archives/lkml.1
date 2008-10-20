Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbYJTHhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbYJTHhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYJTHgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:36:51 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:51607 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYJTHgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:36:50 -0400
Message-Id: <20081020073423.024299308@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Mon, 20 Oct 2008 16:34:23 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [TOMOYO #11 (linux-next) 00/11] TOMOYO Linux
X-OriginalArrivalTime: 20 Oct 2008 07:36:46.0175 (UTC) FILETIME=[9AD9EEF0:01C93286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is a pathname-based MAC extension (LSM module) for the 
Linux kernel.

This patchset is for linux-next (-next-20081017).

Differences from previous version (http://lkml.org/lkml/2008/10/9/46) 
are as follows.

*About locking:
 -reduced global locks.
 -added comments to explain what lock protects.

*About singly-linked-list:
 -moved declaration of singly-linked-list from
  security/tomoyo/common.h to include/linux/list1.h .
 -added rcu_dereference() and rcu_assign_pointer() call properly.

*Others:
 -added MAINTAINERS entry of TOMOYO SECURITY MODULE .
 -inserted a blank line between variable declaration and start of 
code.

Stephen, James, Chris, please review and respond (hopefully Ack).

Regards,
--

