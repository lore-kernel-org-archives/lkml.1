Return-Path: <linux-kernel-owner+w=401wt.eu-S938721AbXFHKdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938721AbXFHKdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934345AbXFHKdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:33:00 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:43413 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbXFHKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:32:59 -0400
Message-ID: <466930D2.9010104@dthaler.de>
Date: Fri, 08 Jun 2007 12:34:58 +0200
From: Daniel Thaler <daniel@dthaler.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070513)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 03/54] NOHZ: Rate limit the local softirq pending warning
 output
References: <20070608072127.352723000@sous-sol.org> <20070608072147.763475000@sous-sol.org>
In-Reply-To: <20070608072147.763475000@sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-RZG-AUTH: huaHjo1TIxLbDubHAaSudCxcykQcnAwlJHTDKN8rKSbbEisd/Zq/2Rn7ynU=
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The warning in the NOHZ code, which triggers when a CPU goes idle with
> softirqs pending can fill up the logs quite quickly.  Rate limit the output
> until we found the root cause of that problem.

Isn't the root cause found and fixed with "[patch 09/54] Prevent going
idle with softirq pending"?

- Daniel

