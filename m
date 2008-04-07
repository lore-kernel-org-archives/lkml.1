Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYDGI6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYDGI6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYDGI6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:58:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbYDGI6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:58:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nikosapi <me@nikosapi.org>
Subject: Re: Suspend on Lenovo 3000 V200 - Linux 2.6.25rc8
Date: Mon, 7 Apr 2008 10:58:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <3e8fd0440804052010xbe8f59bw3268d8206b97ac3e@mail.gmail.com> <200804070123.36912.rjw@sisk.pl> <200804061930.49659.me@nikosapi.org>
In-Reply-To: <200804061930.49659.me@nikosapi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071058.38141.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of April 2008, nikosapi wrote:
> On April 6, 2008 19:23:36 Rafael J. Wysocki wrote:
> > On Monday, 7 of April 2008, nikosapi wrote:
> > > On April 6, 2008 16:21:57 Rafael J. Wysocki wrote:
> > > > On Sunday, 6 of April 2008, Nick Nobody wrote:
[--snip--]
> > >
> > > Hello Rafael,
> > >
> > > I tested with that patch and the problem persists, when the laptop
> > > resumes it locks up (with a black screen). If I add acpi_apic_instance=2
> > > acpi_osi=Linux as kernel boot options (as suggested by my dmesg) when it
> > > resumes I get back to a virtual term but I'm not able to log in. After
> > > entering my username it just hangs there.

Have you tried if doing "echo mem > /sys/power/state" instead of s2ram works?

If you have, what graphics adapter is there in your machine?

Rafael
