Return-Path: <linux-kernel-owner+w=401wt.eu-S942483AbXHNGhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942483AbXHNGhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbXHNGhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:37:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:60878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbXHNGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ty7yMoQjK6+K6cRVRx5aq5/FvZER8RKoPFk4fb94PB5o3wRoDzHhbKR1BLvXtCk8dSgwDMEUn7kFEQgICfq6WaX9hpTPfA6ubueAgZlUtt3fmCn9nDA57u74gS7avtlJzQmH2F2iuwFzEpSsgdRhGXdQktBpMo7Rfet96aqEGHw=
Message-ID: <6bffcb0e0708132337n5d0fe2bbxe4ead92ebca2213a@mail.gmail.com>
Date: Tue, 14 Aug 2007 08:37:13 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [2/4] 2.6.23-rc3: known regressions
Cc: LKML <linux-kernel@vger.kernel.org>, "Len Brown" <len.brown@intel.com>,
       linux-acpi@vger.kernel.org,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <20070813232934.GA1114@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C098FD.1030601@googlemail.com> <46C09BFA.5090604@googlemail.com>
	 <20070813232934.GA1114@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Michal Piotrowski ha scritto:
> > Hi all,
> >
> > Here is a list of some known regressions in 2.6.23-rc3.
> >
> > Feel free to add new regressions/remove fixed etc.
> > http://kernelnewbies.org/known_regressions
> [...]
> >
> > Subject         : FATAL: drivers/acpi/video: sizeof(struct acpi_device_id)=20 is not a modulo of the size of section __mod_acpi_device_table=48
> > References      : http://lkml.org/lkml/2007/8/13/584
> > Last known good : ?
> > Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
>
> Hi Michal,
> this is the same as:
>
> Modpost
>
> Subject         : modpost bug breaks ia64 cross compilation
> References      : http://lkml.org/lkml/2007/7/27/30
>                   http://lkml.org/lkml/2007/7/27/418
> Last known good : ?
> Submitter       : Jan Dittmer <jdi@l4x.org>
> Caused-By       : Thomas Renninger <trenn@suse.de>
>                   commit 29b71a1ca74491fab9fed09e9d835d840d042690
> Handled-By      : ?
> Patch           : http://lkml.org/lkml/2007/8/2/211
> Status          : patch was suggested

Indeed, thanks.

>
> It affects every cross-compilaton from 32 bit host (e.g. x86) to a 64 bit
> target (e.g. x86_64) and (AFAICS, I haven't tried) vice versa.
> Very annoying :|
>
> Luca

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
