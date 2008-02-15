Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYBOJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYBOJCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbYBOJC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:02:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbYBOJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:02:26 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: <dedekind@infradead.org>
Cc: "'linux-mtd'" <linux-mtd@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
References: <004601c86fa2$201a78d0$1fa9580a@swcenter.sec.samsung.co.kr> <1203065647.23414.6.camel@sauron>
Subject: RE: Abnormal behavior with JFFS2 on latest kernel
Date: Fri, 15 Feb 2008 18:02:23 +0900
Organization: infradead
Message-ID: <005601c86fb1$7c79f100$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <1203065647.23414.6.camel@sauron>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-index: AchvsJEjcAGXeaVGR/yrpzUmnVddbQAAIcNA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2008-02-15 at 16:12 +0900, Kyungmin Park wrote:
> > I got following messages.
> > INFO: task pdflush:56 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >
> > What are the meanings?
> > Too mush running GC in JFFS2 or others?
> 
> Hi Kyungmin,
> 
> did not look at this, but off the top of my head this might be related
> to the latest VFS changes (write_begin()/write_end() instead of
> prepare_write()/commit_write()). Just a hint where you might try to
> look.
> 

Then can I use the ubifs? I mean ubifs is already changed for latest VFS changes.
Now I just want to test new driver with latest kernel.

Thank you,
Kyungmin Park

