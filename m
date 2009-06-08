Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZFHGyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZFHGyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZFHGy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:54:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZFHGy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:54:28 -0400
Date: Mon, 8 Jun 2009 08:54:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608065419.GA13568@elte.hu>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906072347.00580.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> +config PM_RUNTIME
> +	bool "Run-time PM core functionality"
> +	depends on PM
> +	---help---
> +	  Enable functionality allowing I/O devices to be put into energy-saving
> +	  (low power) states at run time (or autosuspended) after a specified
> +	  period of inactivity and woken up in response to a hardware-generated
> +	  wake-up event or a driver's request.
> +
> +	  Hardware support is generally required for this functionality to work
> +	  and the bus type drivers of the buses the devices are on are
> +	  responsibile for the actual handling of the autosuspend requests and
> +	  wake-up events.

Halleluya! :-)

	Ingo
