Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbXLON1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbXLON1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbXLON0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:26:53 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:20010 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbXLON0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:26:52 -0500
Date: Sat, 15 Dec 2007 14:26:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Message-ID: <20071215132638.GA28231@basil.nowhere.org>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com> <20071204193432.GI11764@bingen.suse.de> <20071205163017.GA4756@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205163017.GA4756@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Dec 2007 13:20:40.0079 (UTC) FILETIME=[498F51F0:01C83F1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It probably is safe to remove... but we currently support '2.8.95
> kernel loads/resumes 2.6.24 image'... which would break if 2.8 uses
> cr8.

No it won't. 2.8 would just restore some random useless value.
If 2.8 wants to use CR8 it would have to re-initialize it

-Andi
