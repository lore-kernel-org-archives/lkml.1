Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZFGWEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZFGWEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 18:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZFGWEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 18:04:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36328 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZFGWEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 18:04:39 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Mon, 8 Jun 2009 00:05:23 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl>
In-Reply-To: <200906072347.00580.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906080005.23304.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 7. Juni 2009 23:46:59 schrieb Rafael J. Wysocki:
> It may be necessary to resume a device synchronously, but I'm still
> thinking how to implement that.

This will absolutely be the default. You resume a device because you want
it to do something now. It seems to me that you making your problem worse
by using a spinlock as a lock. A mutex would make it easier.

	Regards
		Oliver

