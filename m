Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZLFBuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZLFBuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbZLFBuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:50:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbZLFBuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:50:12 -0500
Date: Sat, 5 Dec 2009 17:50:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <200912060224.37752.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912051745590.3560@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl> <200912060129.19245.rjw@sisk.pl> <alpine.LFD.2.00.0912051648520.3560@localhost.localdomain> <200912060224.37752.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Dec 2009, Rafael J. Wysocki wrote:
> 
> > Multi-function PCI devices commonly share registers - they're on the same
> > chip, after all.  And even when the _hardware_ is totally independent, we
> > often have discovery rules and want to initialize in order because different
> > drivers  will do things like unregister entirely on suspend, and then
> > re-register on resume.
> 
> Do any of the PCI drivers do that?

It used to be common at least for ethernet - there were a number of 
drivers that essentially did the same thing on suspend/resume and on 
module unload/reload.

The point is, I don't know. And neither do you. It's much safer to just do 
drivers one by one, and not touch drivers that people don't test.

			Linus
