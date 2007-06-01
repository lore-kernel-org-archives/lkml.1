Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbXFAWho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbXFAWho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXFAWhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:37:37 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:58849 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbXFAWhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:37:36 -0400
Message-ID: <46609FAD.7010203@dgreaves.com>
Date: Fri, 01 Jun 2007 23:37:33 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl>
In-Reply-To: <200706012342.45657.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 1 June 2007 23:23, David Greaves wrote:
>> Not a regression though, it does it in 2.6.21
>>
>> If I cause the system to save state to disk then whilst off it no longer
>> responds to g-wol.
> 
> Can you please try with the hibernation and suspend patch series from
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/
> 
> applied?
> 
> Greetings,
> Rafael
> 

Sorry I made a mistake in the report.
I was still booting 2.6.21.1 - very sorry :(

The real situation is worse :(

2.6.22-rc3 (no patches) just hangs on suspend at:
Suspending consoles

console switching works but needs a hard reset to reboot.

2.6.22-rc3-skge (with Rafael's patches)
suspends to disk and powers off
wol doesn't work incidentally
resume resumes to the exact same place that 2.6.22-rc3 hangs at...
ie a non-responsive system saying
Suspending consoles

Note, in both cases I can switch VTs, the caps/numlock lights respond.

David




