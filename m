Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbXLMPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbXLMPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbXLMPCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:02:38 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:52954 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754507AbXLMPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:02:37 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Vincent Fortier <vincent.fortier1@ec.gc.ca>
Reply-To: vincent.fortier1@ec.gc.ca
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <1197554397.19869.3.camel@lov.site>
References: <1197554397.19869.3.camel@lov.site>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Environnement Canada
Date: Thu, 13 Dec 2007 15:02:00 +0000
Message-Id: <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 13 Dec 2007 15:02:00.0493 (UTC) FILETIME=[1CF15DD0:01C83D99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 08:59 -0500, Kay Sievers wrote:
> On Thu, 2007-12-13 at 13:55 +0100, Ingo Molnar wrote:
> > * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> >
> > > Could you please see if the following patch removes the oops due
> to
> > > CFS sysfs files? (There might still be the other oops due to the
> > > floppy sysfs files)
> > >
> > > Ingo, could you please add this patch in your CFS backport to
> 2.6.22
> > > and older kernels?
> >
> > sure - i've updated the backport patches with this fix.
> >
> > >  static void user_attr_init(struct subsys_attribute *sa, char
> *name, int mode)
> > >  {
> > > +   sa->attr.owner = NULL;
> > >     sa->attr.name = name;
> >
> > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs
> > initialize the owner field to NULL automatically?
> 
> Attibutes do not have an owner anymore:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b595756ec1f49e0049a9e01a1298d53a7faaa15

This one also fails to apply properly at the exact same place has Ingo's
previously posted patch.  Would need to backport his one.

> Kay

- vin
