Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbYFYOo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbYFYOo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbYFYOhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:37:20 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:36195 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYFYOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:37:18 -0400
Message-Id: <20080625143459.100139455@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Jun 2008 16:34:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/21] s390 printk message cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
this is the first batch of patches of our project to document all s390
specific kernel messages. The first step is to cleanup the existing
messages: remove debugging messages, convert messages to BUG_ON / WARN_ON
and convert messages to debug feature entries.
The second step will be to introduce a new family of print macros that are
then uniformly used in the s390 device drivers.
The third step are the Documentation files and a script that is used to
check the messages and to create man pages from the descriptions.
Steps 2 & 3 are not final yet so this patch set only has the message
cleanup for the next merge window. At large pretty boring stuff ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

