Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXFACqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXFACqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbXFACqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:46:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:51921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXFACqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:46:30 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Date: Thu, 31 May 2007 22:46:11 -0400
User-Agent: KMail/1.9.5
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171842.44134.lenb@kernel.org> <20070521121139.GB8332@elf.ucw.cz>
In-Reply-To: <20070521121139.GB8332@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705312246.11576.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 08:11, Pavel Machek wrote:
> On Thu 2007-05-17 18:42:43, Len Brown wrote:
> > > Something similar happened to me on XE3, yes.
> > > 
> > > (Actual values were different; BIOS specified critical temperature at
> > > cca 95C, but hw killed the power at cca 83C. Setting critical trip
> > > point at 80C made the problem go away.)
> > 
> > Great, please file a bug and include the acpidump from the XE3
> > and we'll fix it, rather than supporting a bogus (manual) workaround for it.
> 
> It is few years since I do not have that XE3 machine.
> 
> > Of course if your system is running at 80*C and the hardware shuts
> > off at 83*C, you may have a broken fan, or one clogged with dust...
> 
> It _did_ have broken fan. It also had broken trip points.

Thanks for clarifying this, Pavel.
If you come upon an XE3 where Linux-2.6.22 doesn't work as well
as Windows, please let me know.

Given that the justification for this ill-conceived workaround
seems to have diminished to the memory of broken hardware,
it is clear that we should stay the course of removing it
so that it doesn't further confuse future users.

If SuSE violently disagrees with me, you are certainly empowered
to restore the workaround in your distribution staring at 2.6.22
as part of your value add.  However, given its history of confusing
users, it seems that it might increase your support burden rather
than decrease it.

-Len
