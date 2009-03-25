Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZCYMJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZCYMJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbZCYMIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:08:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43229 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760429AbZCYMIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:08:02 -0400
Date: Wed, 25 Mar 2009 11:57:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "J.H." <warthog19@eaglescrag.net>
Cc: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       support@osuosl.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@mbligh.org>, "Jorge O. Castro" <jorge@ubuntu.com>,
       bugme-admin@linux-foundation.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Jim Zemlin <jzemlin@linux-foundation.org>
Subject: Re: [KORG] Bugzilla Upgrade / Server move
Message-ID: <20090325115754.7ffb67ce@lxorguk.ukuu.org.uk>
In-Reply-To: <49C9D99D.2050400@eaglescrag.net>
References: <49C9D99D.2050400@eaglescrag.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code base has had a rather extensive upgrade, migrating custom
> fields over to Bugzilla's 3.x custom field support, and dealing with
> kernel.org specific changes.

That has been needed for soooo long - thanks a lot.

> If you have any issues, problems, concerns, please don't hesitate to get
> a hold of me, ftpadmin@kernel.org and/or bugme-admin@linux-foundation.org

Looks basically sound on a quick test. I've closed a lot of the bugs in
our bugzilla against our bugzilla as they are now fixed.

Only glitch so far is formatting (needed a shift-reload to clear the old
style sheet) but then still has problems because the version some people
enter is very very long and that field doesn't have a sensible width
forced in the list format.

There are some other things that need sorting once its settled - a lot of
the owner data and auto-assignment stuff is stale (eg reiser is still
assigned to namesys!) perhaps they should all be assigned to a mailing
list of the form bugzilla-category-subcat so that it becomes entirely
mailman "self service" ?
