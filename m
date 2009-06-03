Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZFCE6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZFCE6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZFCE6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:58:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47559
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbZFCE6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:58:02 -0400
Date: Tue, 02 Jun 2009 21:58:02 -0700 (PDT)
Message-Id: <20090602.215802.149628704.davem@davemloft.net>
To: dan.magenheimer@oracle.com
Cc: rostedt@goodmis.org, tytso@mit.edu, mingo@elte.hu,
       george.dunlap@eu.citrix.com, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir.Fraser@eu.citrix.com,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian.Pratt@eu.citrix.com, xen-users@lists.xensource.com,
       ksrinivasan@novell.com, EAnderson@novell.com, wimcoekaerts@wimmekes.net,
       stephen.spector@citrix.com, jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Merge Xen (the hypervisor) into Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <3ab07e3b-a601-48d5-b350-29cbaf111892@default>
References: <alpine.DEB.2.00.0906022332230.14994@gandalf.stny.rr.com>
	<3ab07e3b-a601-48d5-b350-29cbaf111892@default>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Tue, 2 Jun 2009 21:49:58 -0700 (PDT)

> A hypervisor is not an operating system.

This is a pretty bogus statement if you ask me.

A hypervisor a software system that provides seperation between
protection realms.

It also handles exceptions and "system calls" on behalf of the other
protection realms.

I personally don't see the difference at all.  And since many
hypervisors even do cpu scheduling, the fundamental differences
converge to almost nothing.
