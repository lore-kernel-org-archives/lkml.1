Return-Path: <linux-kernel-owner+w=401wt.eu-S1765155AbYEBACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765155AbYEBACw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYEBACp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:02:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbYEBACp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:02:45 -0400
Date: Thu, 1 May 2008 17:02:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Roth <ryanroth@sbcglobal.net>
Cc: Ryan.Roth@CH2M.com, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
 onMacBookStarting With 2.6.24.5 Kernel
Message-Id: <20080501170239.9b740877.akpm@linux-foundation.org>
In-Reply-To: <481A5276.4040607@sbcglobal.net>
References: <bug-10586-10286@http.bugzilla.kernel.org/>
	<20080501130444.cc5c63e8.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>
	<20080501133003.be723364.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
	<481A5276.4040607@sbcglobal.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 16:29:58 -0700
Ryan Roth <ryanroth@sbcglobal.net> wrote:

> > OK, worried.  This is a huge bug.  But afaik you're the only person 
> > who has
> > hit it, so there must be something special in your setup which is
> > triggering it.  This could be hard.
> >
> 
> OK here is what I get with the git16 kernel.  On boot I get this error:
> 
> PCI: Not using MMCONFIG
> PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard 
> resources
> PCI: Not using MMCONFIG

yeah, mmconfig is a problem.  It should be harmless.  Probably you're
better off with it disabled ;)

> Attached is a complete log after this boot

I see no 'segfault' messages in there?
