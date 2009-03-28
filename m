Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZC1OF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZC1OF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 10:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZC1OFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 10:05:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbZC1OFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:05:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Date: Sat, 28 Mar 2009 15:06:02 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <cjtH6-3Ll-13@gated-at.bofh.it> <20090327153044.3234722d@infradead.org> <49CDFA60.9080403@gmail.com>
In-Reply-To: <49CDFA60.9080403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281506.03364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009, Niel Lambrechts wrote:
> On 03/28/2009 12:30 AM, Arjan van de Ven wrote:
> > On Fri, 27 Mar 2009 21:10:52 +0200
> > Niel Lambrechts <niel.lambrechts@gmail.com> wrote:
> >
> >   
> >> I'm seeing some dubious looking ATA messages even on 2.6.28.9-pae,
> >> although with all the 2.6.28 variants I used s2disk/resume has always
> >> worked. I was wondering if these "errors" perhaps play more of a role
> >> in 2.6.29, perhaps due to the async. changes that was mentioned?
> >>     
> >
> > unless you actively enabled this via a kernel command line option there
> > are no async changes in 2.6.29 in terms of behavior.
> >
> >
> >   
> The only non-default option I had was 'modeset=1'. From Jeff's earlier
> comment I understood the probing behaviour changed.
> 
> The fundamental difference is that in 2.6.29 everything initially seems
> okay, but then there is a
> ata1.00: exception Emask 0x10 SAct 0x3f SErr 0x50000 action0xe frozen
> ata1.00: irq_stat 0x00400008, PHY RDY changed
> 
> There's nothing frozen it 2.6.28.
> 
> Should I log a kernel bug, what's the best way forward and is there
> anything more I can do to help?

Let Tejun have a look a this, perhaps?

Rafael
