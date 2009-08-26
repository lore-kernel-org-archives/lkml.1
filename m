Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZHZUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZHZUvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZHZUvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:51:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbZHZUvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:51:53 -0400
Date: Wed, 26 Aug 2009 13:50:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: mingo@elte.hu, peterz@infradead.org, raziebe@gmail.com,
       maximlevitsky@gmail.com, cfriesen@nortel.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
Message-Id: <20090826135041.e6169d18.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0908261627110.5554@gentwo.org>
References: <1251282598.3514.20.camel@raz>
	<alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	<1251297910.1791.22.camel@maxim-laptop>
	<1251298443.4791.7.camel@raz>
	<1251300625.18584.18.camel@twins>
	<alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	<1251302598.18584.31.camel@twins>
	<alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	<20090826180407.GA13632@elte.hu>
	<alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	<20090826193252.GA14721@elte.hu>
	<alpine.DEB.1.10.0908261627110.5554@gentwo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 16:40:09 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> Peter has not given a solution to the problem. Nor have you.

What problem?

All I've seen is "I want 100% access to a CPU".  That's not a problem
statement - it's an implementation.

What is the problem statement?


My take on these patches: the kernel gives userspace unmediated access
to memory resources if it wants that.  The kernel gives userspace
unmediated access to IO devices if it wants that.  But for some reason
people freak out at the thought of providing unmediated access to CPU
resources.

Don't get all religious about this.  If the change is clean,
maintainable and useful then there's no reason to not merge it.

