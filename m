Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbYBTFdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbYBTFdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYBTFdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:33:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbYBTFdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:33:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=k6z+tNVGza2QZGGVkPXVwkPKBwI9bUIThmP7WsP62qWbHmTUtw9hvhi/HDUwMyVd2
	phtZrmVge/QDWtmL4+BpA==
Message-Id: <20080220051544.018684000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 19 Feb 2008 21:15:44 -0800
From: menage@google.com
To: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org, yamamoto@valinux.co.jp
Subject: [PATCH 0/2] cgroup map files: Add a key/value map file type to cgroups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add a new cgroup control file output type - a map from
strings to u64 values - and make use of it for the memory controller
"stat" file.

It is intended for use when the subsystem wants to return a collection
of values that are related in some way, for which a separate control
file for each value would make the reporting unwieldy.

The advantages of this are:

- more standardized output from control files that report
similarly-structured data

- less boilerplate required in cgroup subsystems

- simplifies transition to a future efficient cgroups binary API

Signed-off-by: Paul Menage <menage@google.com>

--
