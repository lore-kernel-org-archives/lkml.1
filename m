Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYKZUIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYKZUIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYKZUI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:08:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60533 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:08:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <492DAC81.4020803@s5r6.in-berlin.de>
Date: Wed, 26 Nov 2008 21:07:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>	 <492A5557.2010404@s5r6.in-berlin.de> <200811260015.24549.rjw@sisk.pl>	 <200811260031.20079.rjw@sisk.pl> <492CA046.9010501@s5r6.in-berlin.de>	 <b637ec0b0811260019q38564411qf586282984236e22@mail.gmail.com>	 <492D40F7.2040605@s5r6.in-berlin.de> <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com>
In-Reply-To: <b637ec0b0811261145q3c7af010l1db0480d13b41715@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Comolli wrote:
> Ok, I reproduced the bug with 2.6.27.7 without firewire. So the
> firewire stack is innocent after all.

That's great news for me at least.  ;-)

> FWIW, it happened after the resume, as soon as I plugged the AC
> adapter. The system became unresponsive for at least two minutes and
> then "resurrected" as nothing happened. Nothing in the logs and the
> dmesg is clean.
> 
> I ran out of ideas. I'm trying 2.6.27.4, the kernel then never showed
> the problem.

The 2.6.27.5 changelog shows a bunch of ACPI changes.  They may not be
responsible, but in my uninformed opinion these are the changes to look
at more closely.  Since plain bisection did not work well for you, maybe
you should ask the maintainers involved in the ACPI patches for a
priority list of patches to unapply for long-term tests.

Also look at the diffstat whether there were changes to drivers which
you use.

Furthermore, maybe the few scheduler changes may play a role.  But I
don't understand what they do, so I may be completely off.

http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.5
http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2Fv2.6%2Fincr%2Fpatch-2.6.27.4-5.bz2
-- 
Stefan Richter
-=====-==--- =-== ==-=-
http://arcgraph.de/sr/
