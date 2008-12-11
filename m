Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYLKPkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYLKPkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLKPkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:40:31 -0500
Received: from n56.bullet.mail.sp1.yahoo.com ([98.136.44.52]:30092 "HELO
	n56.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756010AbYLKPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:40:31 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 892232.99471.bm@omp202.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=0RLMjGvoEekkexjSqMi/rzEhhwQwB5XZnUhvYYZQBse28GLEIQouc1IHM1XKsBP1C15xOpNRIsSVWavcCUASV6SB9LZFugj59Xr0pDkmeHznVCfxWLyj5k8soHeRYcKzgZQopJdUSc7+qCfoEZRCES6c0wcK7uI1E/pUfdPuOZ4=;
X-YMail-OSG: bvmFdC8VM1nGE7MjoflIcaf5xXWxDqsjhGD1paZ6mqxN33qpZzbIXIyLNuZIhSbjsqDYD_6RZsbJ7M2Iai7V7Byt0bGlw6z4A1dTMDq9._wta_U.7AGpk98lxqKui.ruvHe0qKomQrYrAdn0cica6P.1JUZuZq97vw1ALire6jJyl6oekc2bZyN4AJxOgc2xBmC.i1In9I6HByj.._Kcep.tqJok
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 11 Dec 2008 07:39:20 -0800 (PST)
From: H L <swdevyid@yahoo.com>
Reply-To: swdevyid@yahoo.com
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
To: Yu Zhao <yu.zhao@intel.com>, Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
In-Reply-To: <20081211043340.GA9783@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <772646.16040.qm@web45116.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 12/10/08, Grant Grundler <grundler@parisc-linux.org> wrote:

> Date: Wednesday, December 10, 2008, 10:33 PM
> On Thu, Dec 11, 2008 at 09:43:13AM +0800, Yu Zhao wrote:
> ...
> > I believe this is the only problem that preclude us
> having the run-time
> > resource rebalance. And I'm not sure how much
> effort we can fix it. Any
> > comments?
> 
> Figure out the right sequence for driver resume so the
> probe function
> can call resume as well?
> 
> Document the change and then start modifying drivers
> one-by-one.
> API changes are alot of work.
> 
> grant
> --


I've been lurking awaiting to see such a discussion.  Alerting the PCI drivers that their resources have been changed from underneath them by extending the suspend/resume model, or perhaps (heresy?) adding a new callback entry point specifically for instructing PCI drivers to re-read their BARs, etc. would be a step in the right direction to enable this whole re-balancing work; well, granted root/paging devs bound to PCI devs could be tricky.  It seems entirely natural (to me) that Microsoft would shudder at the amount of work and verification of all drivers to do this, but the Linux community's attitude seems to embrace sweeping changes ;-).

--
LH


      

