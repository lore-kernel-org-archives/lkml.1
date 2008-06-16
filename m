Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYFPC0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYFPC0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 22:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYFPC0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 22:26:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41377 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYFPC0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 22:26:05 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: "'Jason Baron'" <jbaron@redhat.com>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <joe@perches.com>, <greg@kroah.com>,
       <nick@nick-andrew.net>, <randy.dunlap@oracle.com>
References: <20080613185733.GA8813@redhat.com>
In-Reply-To: <20080613185733.GA8813@redhat.com>
Subject: RE: [PATCH 0/8] dynamic debug
Date: Mon, 16 Jun 2008 11:26:12 +0900
Message-ID: <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcjNh4qeQj9YLC+jRaaTajnlYuFMEwBzIa/g
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Jason Baron wrote:
>Each kernel sub-system seems to have its own way of dealing with 
>debugging statements. Some of these methods include 'dprintk', 
>'pr_debug', 'dev_debug', 'DEBUGP'. There are also a myriad of 
>ways of enabling these statements. 

 I propose to replace 'Pr_debug', 'Dev_debug', and 'DEBUGP' with 
kernel markers. SystemTap is used for the output of the log.  

 I propose to make it to the function to output only specified 
kernel markers as a log and the function in a word like LTTng of
a simple version by using the framework and kernel markers of 
ftrace if the log is output by using debugfs. 

Thank you,

--
Takashi Nishiie



