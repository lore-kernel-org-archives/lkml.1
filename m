Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYJJObp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYJJObp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYJJObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:31:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51607 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755105AbYJJObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:31:36 -0400
Date: Fri, 10 Oct 2008 10:31:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] WARNING: at kernel/power/main.c:176
 suspend_test_finish+0x70/0x80()
In-Reply-To: <200810101452.27929.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0810101028260.2459-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Rafael J. Wysocki wrote:

> On Friday, 10 of October 2008, Parag Warudkar wrote:
> > 2.6.27 seems to be taking long time to resume, it hits this WARN_ON in
> > kernel/power/main.c:176 suspend_test_finish -
> > Never seen earlier.
> 
> Resuming devices takes too much time (more than 5 sec. actually)
> and the stack trace indicates USB.
> 
> Can you test with the USB modules unloaded?

There's a bug that affects USB power management: commmit 
f9dd45ce10a014bdfd5432828c44630ea7fefedd needs to be reverted.  Greg KH
has been asked to do this a few times but he hasn't gotten around to it 
yet.

Alan Stern

