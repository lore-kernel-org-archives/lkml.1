Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZLTD7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZLTD7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 22:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZLTD7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 22:59:10 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52611 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753134AbZLTD7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 22:59:08 -0500
Date: Sat, 19 Dec 2009 22:59:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912200040.18944.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912192253200.6618-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:

> So, seriously, do you think it makes sense to do asynchronous suspend at all?
> I'm asking, because we're likely to get into troubles like this during suspend
> for other kinds of devices too and without resolving them we won't get any
> significant speedup from asynchronous suspend.
> 
> That said, to me it's definitely worth doing asynchronous resume with the
> "start asynch threads upfront" modification, as the results of the tests show
> that quite clearly.  I hope you agree.

It's too early to come to this sort of conclusion (i.e., that suspend
and resume react very differently to an asynchronous approach).  Unless
you have some definite _reason_ for thinking that resume will benefit
more than suspend, you shouldn't try to generalize so much from tests
on only two systems.

Alan Stern

