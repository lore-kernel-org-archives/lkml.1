Return-Path: <linux-kernel-owner+w=401wt.eu-S1761798AbYHEQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbYHEQgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYHEQgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:36:39 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52042 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbYHEQgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:36:38 -0400
Subject: Re: [PATCH 2/2] fusion:  Implement generic interrupt misroute
	handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>
In-Reply-To: <48970A4D.2090309@csr.com>
References: <1217786709.4179.27.camel@localhost.localdomain>
	 <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
	 <48970A4D.2090309@csr.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 09:36:27 -0700
Message-Id: <1217954187.9923.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 14:55 +0100, David Vrabel wrote:
> Moore, Eric wrote:
> > Thanks, I will try this out.   However I thought I saw lost
> > interrupts occurring randomly, meaning it was not necessarily the
> > first config page access.  I'm back in the office on 8/11, I will
> > test it out then and provide feedback.
> 
> Is this using MSI on a device without per-vector mask bits?  If so, then
> this patch may help.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd

We don't really know what the problem is.  MSI interrupts get lost on
older motherboards (the ones most likely to contain a 1030).  Why is
anybody's guess although the clever money is on the motherboard bridge
having issues.

James


