Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbXFOV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbXFOV6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXFOV5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:57:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbXFOV5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:57:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Greaves <david@dgreaves.com>
Subject: Re: 2.6.22-rc4 hibernate disables skge wol
Date: Sat, 16 Jun 2007 00:04:30 +0200
User-Agent: KMail/1.9.5
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-pm <linux-pm@lists.osdl.org>
References: <467309B8.2060001@dgreaves.com>
In-Reply-To: <467309B8.2060001@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706160004.30932.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 June 2007 23:50, David Greaves wrote:
> I've started a new thread here since the old one got somewhat hijacked.
> 
> Rafael J. Wysocki wrote:
>  > On Friday, 1 June 2007 23:23, David Greaves wrote:
>  >> Not a regression though, it does it in 2.6.21
>  >>
>  >> If I cause the system to save state to disk then whilst off it no longer
>  >> responds to g-wol.
>  >
>  > Can you please try with the hibernation and suspend patch series from
>  >
>  > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/
>  >
>  > applied?
>  >
>  > Greetings,
>  > Rafael
>  >
>  >
> Now, IIRC, some time ago you asked me to try some patches :)
> 
> So I applied them (and Tejun's fixes as per the old thread) to rc4 (which seems 
> to include a couple already).
> 
> Hibernate/resume works but although WOL works on an init 0, it doesn't work on a 
> hibernated system :(

Well, I have one idea, but I'd like the recent paches currently in -mm to
settle down before trying it. ;-)

In the meantime, you may want to open a bugzilla entry related to this issue
(please add my address to the CC list if you do that).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
