Return-Path: <linux-kernel-owner+w=401wt.eu-S935134AbYBUVft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbYBUVft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbYBUVfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:35:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:52442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760880AbYBUVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:35:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=gI+Z7ARORh7PUNuxnlak7NXxb4WuPPzeLLUK71X19ajhB0VpCnVd3jmEzwSkHNWEc
	YdefPeZJFoMagOuWc3DDg==
Message-Id: <20080221212854.408662000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Thu, 21 Feb 2008 13:28:54 -0800
From: menage@google.com
To: kamezawa.hiroyu@jp.fujitsu.com, yamamoto@valinux.co.jp,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: [PATCH 0/2] cgroup map files: Add a key/value map file type to cgroups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Updated from the previous version to remove the colon from the map output ]

These patches add a new cgroup control file output type - a map from
strings to u64 values - and make use of it for the memory controller
"stat" file.

It is intended for use when the subsystem wants to return a collection
of values that are related in some way, for which a separate control
file for each value would make the reporting unwieldy.

The advantages of this are:

- more standardized output from control files that report
similarly-structured data that needs to be parsed programmatically

- less boilerplate required in cgroup subsystems

- simplifies transition to a future efficient cgroups binary API

Signed-off-by: Paul Menage <menage@google.com>


--
