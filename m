Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbXLQRJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbXLQRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXLQRJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:09:20 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:39195 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbXLQRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nhFKHxBnxyd1Wa15H0B6OnFZLXUJwBpNociW5Sea5yA1jcytyxsQrAZdOn+soqn4U/I/cwF8FPrKx23E1b9nOVuEMiBj075LQeNYktkjG+N0RyTgihx4sMUMrpo0sY40P2RRToHvbJzklt32RtJk4q2028qliyd8Wazve67HTM8=
Message-ID: <87f94c370712170909y691dc2e3rf7f23c64eff8da22@mail.gmail.com>
Date: Mon, 17 Dec 2007 12:09:17 -0500
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: ATA bus error with external hd on esata
Cc: "Zsolt Barat" <zsolt@softmonsters.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
In-Reply-To: <20071217025321.2f7507db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47642D9A.4080600@softmonsters.com>
	 <476434C7.6040307@softmonsters.com>
	 <20071217025321.2f7507db.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 5:53 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 15 Dec 2007 21:10:47 +0100 Zsolt Barat <zsolt@softmonsters.com> wrote:
>
> > Zsolt Barat schrieb:
> > > hi list,
>
> Let's cc the IDE development list.
>
> > > i just bought a "MyBook" called external HD with a fixed enclosure, from
> > > WD. Connected to the SATA port i constantly get "ATA bus error" messages
> > > in the kernel log. Is this a known issue?
> > >

As an FYI: I've had a lot of problems with the big prepackaged drives
in the last 6 months even from Windows, so I would not be too quick to
blame Linux.

ie.
I bought several 500GB / 1000GB Buffalo Drives last month with plans
to use them from Windows via USB.

I attempted to do a lot of heavy file copying to/from them.  I was
getting a bunch of "Delayed Write Failures",

I finally gave up.

The 500GB drives had a single hard drive internally, so I opened the
case, removed the drive and connected them via standalone external
carriers I had around.  In that mode the drives worked fine (from
Windows).  I've used both standalone eSata external carriers and
standalone USB external carriers with these same physical drives with
no issues.

My conclusion is that the electronics in the prepackaged external
units is just not up to the job if your doing heavy i/o.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
