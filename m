Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbYF0Rw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbYF0Rw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYF0Rwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:52:49 -0400
Received: from 8bytes.org ([88.198.83.132]:39408 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYF0Rwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:52:49 -0400
Date: Fri, 27 Jun 2008 19:52:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com,
       Ben-Ami Yassour1 <BENAMI@il.ibm.com>
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627175247.GH10197@8bytes.org>
References: <878wwrq6im.fsf@basil.nowhere.org> <20080627163945.GA26130@il.ibm.com> <20080627165430.GD10197@8bytes.org> <20080627165947.GB26130@il.ibm.com> <20080627170546.GE10197@8bytes.org> <20080627171201.GC26130@il.ibm.com> <20080627172030.GF10197@8bytes.org> <20080627173100.GD26130@il.ibm.com> <20080627174034.GG10197@8bytes.org> <20080627174415.GF26130@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627174415.GF26130@il.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 01:44:15PM -0400, Muli Ben-Yehuda wrote:
> On Fri, Jun 27, 2008 at 07:40:35PM +0200, Joerg Roedel wrote:
> 
> > Yes. As I said, this is for the non-isolating case. For the
> > isolation case (which is needed for protection) it is harder to
> > optimize. But there I think about some sort of lazy IOMMU TLB
> > flushing. The flushing and 'wait for the flush to finish' is the
> > most expensive part in the mapping and unmapping code path. But this
> > needs some experiments.
> 
> Agreed. The paper I just posted to the iommu mailing list has some
> ideas and experimental data.

Cool. I wasn't aware if that paper. I will read it next week. Thanks for
the pointer to it.

Joerg

