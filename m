Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZGHKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZGHKj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZGHKjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:39:49 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:42277 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZGHKjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:39:48 -0400
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <4A4B0125.2090502@crca.org.au>
	<87d48k2992.fsf@jeremyms.com> <4A4B27D0.8020906@crca.org.au>
	<20090704024432.GB1345@ucw.cz>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Wed, 08 Jul 2009 03:47:53 -0700
In-Reply-To: <20090704024432.GB1345@ucw.cz> (Pavel Machek's message of "Sat,
	04 Jul 2009 04:44:32 +0200")
Message-ID: <87hbxn78o6.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

[snip]

> I believe uswsusp could be used rather easily. Just modify s2disk to
> encrypt image in ram without writing it out, then decrypt it from ram
> and resume... it should be interesting hack.

As far as I understand, that would be completely useless since the image
that would be encrypted would just be a copy of what would still remain
in memory.

-- 
Jeremy Maitin-Shepard
