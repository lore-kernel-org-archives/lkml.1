Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbYJVEM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbYJVEM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbYJVEMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:12:15 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:45412 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYJVEMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:12:14 -0400
Date: Wed, 22 Oct 2008 00:11:51 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
In-reply-to: <200810212137.58020.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Message-id: <alpine.LFD.1.10.0810220008050.2984@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_vc5q/OpJuzKVOLp+ZFuIHg)"
References: <20081017171139.GA1792@elte.hu> <87r66ejqla.fsf@basil.nowhere.org>
 <20081021111716.GA4476@elte.hu> <200810212137.58020.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_vc5q/OpJuzKVOLp+ZFuIHg)
Content-type: TEXT/PLAIN; charset=utf-8
Content-transfer-encoding: 8BIT



> >   drivers/acpi/sleep/main.c:67: warning: ‘acpi_pm_disable_gpes’ defined but not used

> > 
> > Shows that this code has an identity crisis due to a maze of #ifdefs, in
> > the PM_SLEEP && !SUSPEND && !HIBERNATION case for example.
> 
> This case is invalid, because PM_SLEEP == SUSPEND || HIBERNATION !

I though so too, but 2.6.27 appears to have added XEN to the mix:

config PM_SLEEP
        bool
        depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE

-Len

--Boundary_(ID_vc5q/OpJuzKVOLp+ZFuIHg)--
