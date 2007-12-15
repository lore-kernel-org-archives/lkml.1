Return-Path: <linux-kernel-owner+w=401wt.eu-S1764371AbXLOUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764371AbXLOUdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 15:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXLOUdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 15:33:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbXLOUdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 15:33:05 -0500
Message-ID: <476438E8.8090805@zytor.com>
Date: Sat, 15 Dec 2007 12:28:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andi Kleen <ak@suse.de>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com> <20071204193432.GI11764@bingen.suse.de> <20071205163017.GA4756@ucw.cz>
In-Reply-To: <20071205163017.GA4756@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> It probably is safe to remove... but we currently support '2.8.95
> kernel loads/resumes 2.6.24 image'... which would break if 2.8 uses
> cr8.
> 
> So please keep it if it is not a big problem.
> 

Note that CR8 is an alias for the TPR in the APIC.

	-hpa
