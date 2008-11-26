Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYKZXDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYKZXDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYKZXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:03:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbYKZXDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:03:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Date: Thu, 27 Nov 2008 00:02:29 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Fenlason <fenlason@redhat.com>
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com> <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com> <492DAC81.4020803@s5r6.in-berlin.de>
In-Reply-To: <492DAC81.4020803@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811270002.29537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of November 2008, Stefan Richter wrote:
> Fabio Comolli wrote:
> > Ok, I reproduced the bug with 2.6.27.7 without firewire. So the
> > firewire stack is innocent after all.
> 
> That's great news for me at least.  ;-)
> 
> > FWIW, it happened after the resume, as soon as I plugged the AC
> > adapter. The system became unresponsive for at least two minutes and
> > then "resurrected" as nothing happened. Nothing in the logs and the
> > dmesg is clean.
> > 
> > I ran out of ideas. I'm trying 2.6.27.4, the kernel then never showed
> > the problem.
> 
> The 2.6.27.5 changelog shows a bunch of ACPI changes.  They may not be
> responsible, but in my uninformed opinion these are the changes to look
> at more closely.  Since plain bisection did not work well for you, maybe
> you should ask the maintainers involved in the ACPI patches for a
> priority list of patches to unapply for long-term tests.

Actually, yes, Fabio, you can try to revert all of the "ACPI: EC:" commits
applied after 2.6.27.4 and retest.

Thanks,
Rafael
