Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZJFAPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZJFAPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbZJFAPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:15:06 -0400
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:42242 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755689AbZJFAPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:15:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jjr5XaPH2PDYe6dlLnmNDlxKWuWU8PmWKrUskvYzyr88hsf3UG1TH/fgVxsc7QcCCWSDu6EXb2gFlxWEUNf549gNnl1oJ3XBAe71/tlgku5SOfe8YHREiyLWEVakqtJh;
Date: Mon, 5 Oct 2009 17:14:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Kay, Allen M" <allen.m.kay@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>
Subject: Re: [PATCH ACS v3 1/1]
Message-ID: <20091005171419.5464502d@jbarnes-g45>
In-Reply-To: <20091001011721.GK3958@sequoia.sous-sol.org>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
	<20090929000041.GB3958@sequoia.sous-sol.org>
	<57C9024A16AD2D4C97DC78E552063EA3E2EA3B70@orsmsx505.amr.corp.intel.com>
	<20090929184650.GF3958@sequoia.sous-sol.org>
	<57C9024A16AD2D4C97DC78E552063EA3E2F0411F@orsmsx505.amr.corp.intel.com>
	<20091001011721.GK3958@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 18:17:21 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Kay, Allen M (allen.m.kay@intel.com) wrote:
> > On the other hand, can we say VT-d PT mode is mainly for KVM
> > virtualization use case?  If so, is it reasonable to say
> > performance of host P2P in this mode is not of highest priority?
> 
> Guess it depends on the workload.  Would be helpful to identify a use
> case that is p2p heavy (and then the impact of enabling ACS).
> 
> > If not, another option is to have a kernel boot parameter to
> > configure an kernel boot instance to be either host kernel
> > optimized or virtualization optimized.  I don't know whether this
> > is a reasonable or not ...
> 
> I was thinking that ACS could be enabled if an IOMMU is enabled.  Not
> a perfect fit, but seems reasonably close.

Allen, did you want to do these changes as an incremental patch on your
last one or just send me a replacement?  Either way is fine with me.

-- 
Jesse Barnes, Intel Open Source Technology Center
