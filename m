Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXDMQEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXDMQEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXDMQEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:04:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48371 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbXDMQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:04:34 -0400
Date: Fri, 13 Apr 2007 09:06:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org
Subject: make clean for DocBook
Message-Id: <20070413090658.b4c4bc8f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

'make clean' doesn't seem to descend into Documentation/DocBook/.
At least 'make V=1 clean' doesn't show me any references in DocBook.

I guess that this is because DocBook doesn't have anything that
qualifies in obj-y/m/n and subdir-y/m/n.  (?)

Do you have any recommendations for this?

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
