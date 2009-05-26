Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZEZPct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZEZPct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZEZPcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:32:41 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:61938 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbZEZPck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:32:40 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Date: Tue, 26 May 2009 17:30:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <200905252224.37012.elendil@planet.nl> <200905260102.29455.rjw@sisk.pl>
In-Reply-To: <200905260102.29455.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905261730.53041.elendil@planet.nl>
X-OriginalArrivalTime: 26 May 2009 15:32:41.0501 (UTC) FILETIME=[353464D0:01C9DE17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Rafael J. Wysocki wrote:
> On Monday 25 May 2009, Frans Pop wrote:
> > Rafael J. Wysocki wrote:
> > > If you know of any other unresolved regressions from 2.6.29, please
> > > let me know either and I'll add them to the list.
> >
> > It may be worth tracking a possible regression introduced with -rc6
> > as a result of http://bugzilla.kernel.org/show_bug.cgi?id=13259.
> >
> > A new warning that was added in drivers/acpi/processor_throttling.c
> > (commit 4973b22a: 'ACPI processor: reset the throttling state once
> > it's invalid') may be triggering in cases where it shouldn't. It
> > seems to trigger during boot and on 'cat
> > /proc/acpi/processor/*/throttling'. Otherwise it's probably
> > relatively harmless.
> >
> > See the comments starting at #23 for details.
>
> Hmm.  It's really better if you file a separate bug for that with a
> reference to the previous discussion.

Done (after doing additional debugging):
http://bugzilla.kernel.org/show_bug.cgi?id=13389

Marked as regression and set as blocking for #13070.

Cheers,
FJP
