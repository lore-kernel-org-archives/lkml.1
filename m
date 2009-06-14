Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZFNKzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZFNKzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZFNKyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:54:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:32976 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754625AbZFNKyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:54:52 -0400
X-Authenticated: #3576790
X-Provags-ID: V01U2FsdGVkX1/K2etqwPTKZYSagY8nnn/dNi0gDNiGyS5v14ib+g
	IVwDE2xW73mE1O
Date: Sun, 14 Jun 2009 12:57:04 +0200
From: "Benjamin S." <sbenni@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, js@sig21.net
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090614125704.2240023d@pluto-lenny.milky.way>
In-Reply-To: <200906141235.24942.rjw@sisk.pl>
References: <20090614120950.116536fa@pluto-lenny.milky.way>
	<200906141235.24942.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 14 Jun 2009 12:35:24 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Thanks for the report, the problem seems to be related to the chipset, because
> I'm unable to reproduce it with SB600 and a fairly new AMD CPU.
> 
> Does the resume work if you comment out suspend_device_irqs() and
> resume_device_irqs() in drivers/base/power/main.c ?

Yes, 2.6.30 without the two lines resumes without problems.


Benjamin
