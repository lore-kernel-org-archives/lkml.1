Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZGNAQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZGNAQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZGNAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:16:24 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:47195 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751008AbZGNAQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:16:23 -0400
From: Vladislav Buzov <vbuzov@embeddedalley.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Linux memory management list <linux-mm@kvack.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 0/2] Memory usage limit notification feature (v3)
Date: Mon, 13 Jul 2009 17:16:19 -0700
Message-Id: <1247530581-31416-1-git-send-email-vbuzov@embeddedalley.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
References: <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following sequence of patches introduce memory usage limit notification
capability to the Memory Controller cgroup.

This is v3 of the implementation. The major difference between previous
version is it is based on the the Resource Counter extension to notify the
Resource Controller when the resource usage achieves or exceeds a configurable
threshold.

TODOs:

1. Another, more generic notification mechanism supporting different  events
   is preferred to use, rather than creating a dedicated file in the Memory
   Controller cgroup.


Thanks,
Vlad.
