Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbXGaJOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbXGaJOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXGaJOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:14:37 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:49736 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752585AbXGaJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:14:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH 2/2] Introduce CONFIG_SUSPEND (updated)
Date: Tue, 31 Jul 2007 11:16:39 +0200
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Nigel Cunningham <nigel@nigel.suspend2.net>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       linux-acpi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707310059.50329.lenb@kernel.org> <200707311115.29057.rjw@sisk.pl>
In-Reply-To: <200707311115.29057.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311116.39857.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 Juli 2007 schrieb Rafael J. Wysocki:

> Well, the people on linux-pm seem to agree that the .suspend() and .resume()
> callbacks are not suitable for runtime power management, so having them
> built without SUSPEND or HIBERNATION wouldn't be very useful. ;-)

These are what USB runtime power management uses. How many code
paths for power management do you want to introduce?

	Regards
		Oliver
