Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0BTOAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:00:12 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0BTOAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:00:10 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       ebiederm@xmission.com, gregkh@suse.de
In-Reply-To: <20100220135431.GC3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664429.11514.3.camel@jlt3.sipsolutions.net>
	 <20100220135431.GC3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 15:00:06 +0100
Message-ID: <1266674406.18465.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 21:54 +0800, Américo Wang wrote:

> > 	/* Allocated above after the legacy_io struct */
> >-	sysfs_bin_attr_init(&b->legacy_mem);
> > 	b->legacy_mem = b->legacy_io + 1;
> >+	sysfs_bin_attr_init(b->legacy_mem);

Also note the reordering to make it not crash ...

johannes

