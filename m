Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXIYXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXIYXmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXIYXmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:42:09 -0400
Received: from ozlabs.org ([203.10.76.45]:36854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbXIYXmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:08 -0400
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jonathan Corbet <corbet@lwn.net>,
       ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F996AD.2070107@gmail.com>
References: <Pine.LNX.4.44L0.0709251105540.3909-100000@iolanthe.rowland.org>
	 <46F996AD.2070107@gmail.com>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 09:41:44 +1000
Message-Id: <1190763704.2227.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 08:15 +0900, Tejun Heo wrote:
> I have no problem with changing the condition check to loop but it would
> be great if someone can point me to a code where this unexpected wake up
> is used.

This is one of those areas where we're conservative.  Historically there
have been random wakes, and noone is quite sure that signal code or the
freezer or whatever won't do it under some circumstances.

Thus it's always seen as better to wait on a specific condition.

Cheers,
Rusty.

