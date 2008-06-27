Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYF0RFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYF0RFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYF0RFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:05:48 -0400
Received: from 8bytes.org ([88.198.83.132]:57194 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYF0RFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:05:48 -0400
Date: Fri, 27 Jun 2008 19:05:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627170546.GE10197@8bytes.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-2-git-send-email-joerg.roedel@amd.com> <20080627142558.GG18644@cs181140183.pp.htv.fi> <878wwrq6im.fsf@basil.nowhere.org> <20080627163945.GA26130@il.ibm.com> <20080627165430.GD10197@8bytes.org> <20080627165947.GB26130@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627165947.GB26130@il.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 12:59:47PM -0400, Muli Ben-Yehuda wrote:
> On Fri, Jun 27, 2008 at 06:54:30PM +0200, Joerg Roedel wrote:
> 
> > True. At least for the case without device isolation I have some
> > optimizations in mind which will minimize the performance
> > tradeoff. I hope to have them ready for 2.6.28 :)
> 
> Do you mean the case where you have a single I/O address space which
> is shared by all devices?

Yes. I think this will be the case used most when IOMMU is used for
virtualization and to handle devices with limited DMA address ranges. In
this case there is a lot to optimize.

Joerg

