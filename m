Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYEFWMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYEFWMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYEFWLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:11:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYEFWL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:11:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/2] Freezer face lifting
Date: Wed, 7 May 2008 00:03:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805070003.56387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Although the freezer is generally considered as a bad thing, it still is
being used for suspend and hibernation and will be used for these purposes in
the near future.  For this reason, it seems reasonable to try to reduce some
known problems with it.  The following two patches attempt to do that.

First, it is the known weakness of the freezer that it tries to distinguish
user space processes from kernel threads in a slightly artificial way.  The
first patch is intended to change that.

Second, in principle, the freezer can use the recently introduced TASK_KILLABLE
state to handle some cases that it couldn't have handled previously, which is
the purpose of the second patch.

Please review and tell me what you think.

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

