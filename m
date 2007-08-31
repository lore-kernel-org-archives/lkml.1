Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbXHaI5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbXHaI5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXHaI5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:57:41 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:37691 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbXHaI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:57:40 -0400
In-Reply-To: <20070830212816.GA4263@austin.ibm.com>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       jschopp <jschopp@austin.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>, Nathan Lynch <ntl@pobox.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD83AA06B.BECCA59D-ONC1257348.0030CA33-C1257348.003132C0@de.ibm.com>
Date: Fri, 31 Aug 2007 10:57:28 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 31/08/2007 10:57:30,
	Serialize complete at 31/08/2007 10:57:30
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linas@austin.ibm.com (Linas Vepstas) wrote on 30.08.2007 23:28:16:

> On Thu, Aug 30, 2007 at 04:00:56PM +0200, Joachim Fenkes wrote:
> > 
> > Plus, I rather like using 
> > the full_name since it also contains a descriptive name as opposed to 
> > being just nondescript numbers, helping the layman (ie user) to make 
sense 
> > out of a dev_id.
>
> [...]
> Location codes are nice. 

I sure agree with you. Still, they're not unique, so we can't use them as 
bus_id. That's why we're having this discussion at all.

What I meant was "I like using the full_name over using the device address 
/ DRC index / you-name-it only". Location code is right out.

Cheers,
  Joachim
