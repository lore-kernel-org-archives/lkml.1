Return-Path: <linux-kernel-owner+w=401wt.eu-S938553AbXHMXaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938553AbXHMXaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937165AbXHMX3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:29:44 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:60677 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937463AbXHMX3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hPNWwubtZZXN1MxpU9hlJlwHeYtssVROwj0tUsKiZSdeCNUy4sXKD1npwb/lGerRJrvYRjyng+0o+RMNTygzUYUDWYeBrnjxAB/ckP7HSuIWHRH4puyozpNbWOR2pbtaPb6RaqfFttB58476/TqSwEW5y3J803yNrprARQvcmUo=
Date: Tue, 14 Aug 2007 01:29:34 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [2/4] 2.6.23-rc3: known regressions
Message-ID: <20070813232934.GA1114@dreamland.darkstar.lan>
References: <46C098FD.1030601@googlemail.com> <46C09BFA.5090604@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C09BFA.5090604@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski ha scritto: 
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc3.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
[...]
> 
> Subject         : FATAL: drivers/acpi/video: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=48
> References      : http://lkml.org/lkml/2007/8/13/584
> Last known good : ?
> Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

Hi Michal,
this is the same as:

Modpost

Subject         : modpost bug breaks ia64 cross compilation
References      : http://lkml.org/lkml/2007/7/27/30
                  http://lkml.org/lkml/2007/7/27/418
Last known good : ?
Submitter       : Jan Dittmer <jdi@l4x.org>
Caused-By       : Thomas Renninger <trenn@suse.de>
                  commit 29b71a1ca74491fab9fed09e9d835d840d042690
Handled-By      : ?
Patch           : http://lkml.org/lkml/2007/8/2/211
Status          : patch was suggested

It affects every cross-compilaton from 32 bit host (e.g. x86) to a 64 bit
target (e.g. x86_64) and (AFAICS, I haven't tried) vice versa.
Very annoying :|

Luca
-- 
"New processes are created by other processes, just like new
 humans. New humans are created by other humans, of course,
 not by processes." -- Unix System Administration Handbook
