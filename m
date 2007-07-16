Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXGPOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXGPOxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXGPOxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:53:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51522 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753751AbXGPOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:53:33 -0400
Date: Mon, 16 Jul 2007 10:53:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Al Boldi <a1426z@gawab.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, <david@lang.hm>
Subject: Re: Hibernation considerations
In-Reply-To: <200707160802.46567.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.44L0.0707161045520.3410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Al Boldi wrote:

> From a kexec'd hibernation kernel pov, both S3 and S4 look conceptually 
> exactly the same.  The only difference is, in S3 the memory is in memory and 
> in S4 the memory is on storage.  All device handling is exactly the same, so 
> if there is a problem with device handling between the kexec'd hibernation 
> kernel and the normal kernel, then that would have made itself visible.

You have contradicted yourself.  "In S3 the memory is in memory and in
S4 the memory is on storage".  How does the memory get onto storage?  
The kexec'd hibernation kernel writes it there.  To do so it accesses a 
storage device.

Consequently the device handling _cannot_ be exactly the same in S3 and
S4.

Alan Stern

