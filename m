Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYBZIZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYBZIZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYBZIZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:25:10 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:56718 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYBZIZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:25:09 -0500
Message-ID: <47C3CD15.1060908@davidnewall.com>
Date: Tue, 26 Feb 2008 18:55:57 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
References: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org> <200802252325.09439.rjw@sisk.pl> <200802252313.23399.david-b@pacbell.net>
In-Reply-To: <200802252313.23399.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> This "flaw" isn't a new thing, of course.  I remember pointing out the rather
> annoying proclivity of the PM framework to deadlock when suspend() tried to
> remove USB devices ... back around 2.6.10 or so.  Things have shuffled around
> a bit, and gotten better in some cases, but not fundamentally changed.

Hardware can be inserted and removed while we're in a suspend state; and
there's nothing that we can do about it until we resume.  Is it fair to
say, then, that having started suspend, we could reasonably ignore any
device insertion and removal, and handle it on resume?  Presumably we
need to scan for hardware changes on resume.
