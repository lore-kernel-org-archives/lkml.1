Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZGGUZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZGGUZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZGGUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:25:13 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:57697 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754946AbZGGUZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:25:12 -0400
From: Vladislav Buzov <vbuzov@embeddedalley.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 0/1] Memory usage limit notification addition to memcg
Date: Tue,  7 Jul 2009 13:25:09 -0700
Message-Id: <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

The following patch introduces memory usage limit notification capability to
the Memory Controller cgroup. It is a reworked version of a patch sent by Dan
Malek in April 2009.

The major difference between this and original patches is a modified method of
notification threshold setting. The original patch implemented threshold as a
percentage of the memory controller limit. During following discussion it's
been decided to change percentage to an absolute number representing the
minimal amount of memory that should be available below the limit. The
following patch implements this method along with various clean-ups and style
changes.

Thanks,
Vlad.
