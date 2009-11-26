Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZKZQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZKZQ2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZKZQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:28:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55064 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbZKZQ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:28:03 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v0 3/3] memcg: implement memory thresholds
Date: Thu, 26 Nov 2009 18:27:38 +0200
Message-Id: <d977350fcc9bc3e1fe484440c1fc3a7470a4e26b.1259248846.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <8524ba285f6dd59cda939c28da523f344cdab3da.1259248846.git.kirill@shutemov.name>
References: <cover.1259248846.git.kirill@shutemov.name>
 <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259248846.git.kirill@shutemov.name>
 <8524ba285f6dd59cda939c28da523f344cdab3da.1259248846.git.kirill@shutemov.name>
In-Reply-To: <cover.1259248846.git.kirill@shutemov.name>
References: <cover.1259248846.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows to register multiple memory thresholds and gets notifications
when it crosses.

To register a threshold application need:
- create an eventfd;
- open file memory.usage_in_bytes of a cgroup
- write string "<event_fd> <memory.usage_in_bytes> <threshold>" to
  cgroup.event_control.

Application will be notified through eventfd when memory usage crosses
threshold in any direction.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
1.6.5.3

