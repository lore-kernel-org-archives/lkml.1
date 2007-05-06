Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXEFWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXEFWrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXEFWrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:47:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52218 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXEFWre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G3wE9Q1QpVFZ2jUJmgP7NddvvOunC+LCy/3p303dHP4ASbJ4cl6/H0UapF8QsSMbk+7N+AH2U5FcHgK+lTe+CV8zVR0V/FLJeKI2fAtwVBvtATk/TMsMx+qzV7uCe6+44/apEC/ssNW61xE5xeYae3Rp8DEFF4aDHfeB8A0GW6A=
Message-ID: <e9c3a7c20705061547u7de21fas6ccad4258da57a9e@mail.gmail.com>
Date: Sun, 6 May 2007 15:47:32 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: [2.6.22 patch] iop: combined watchdog timer driver for iop3xx and iop13xx
Cc: "Curt E. Bruns" <curt.e.bruns@intel.com>,
       "Peter Milne" <peter.milne@d-tacq.com>,
       "Russell King" <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       "Lennert Buytenhek" <buytenh@wantstofly.org>
In-Reply-To: <20070506205320.GA6486@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com>
	 <20070506095256.GA2521@infomag.infomag.iguana.be>
	 <e9c3a7c20705061313g2b110c4ai478bd3d345de3114@mail.gmail.com>
	 <20070506205320.GA6486@infomag.infomag.iguana.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Dan,
>
> > >Could you split this patch into 2 patches: one that deals with the moving
> > >of
> > >the architecture dependant code (and explaining why) and one with the new
> > >watchdog drivers? I will continue my review today.
> > >
> >
> > I am one of the maintainers of this architecture, (Lennert Buytenhek
> > is the other).  I will go ahead and split this up so you can sign-off
> > on the watchdog specific bits.  The intent is to move all hardware
> > definitions under #include <asm/hardware.h>.  You are right this
> > should have been a separate patch.
>
> I reviewed the rest of the code. Looks OK to me. One small remark though:
> Can we change the ifdef's in the code as described in section 2 point 2 of
> the Documentation/SubmittingPatches document?
>
Ok, I can add this cleanup.

Barring any objections I'll go ahead and submit the revised patch with
an "Acked-by: Wim Van Sebroeck <wim at iguana dot be>" to Russell's
ARM patch tracker.

> Thanks,
> Wim.
>

Dan
