Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYJNM3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYJNM3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYJNM3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:29:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40404 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbYJNM3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:29:21 -0400
Subject: Re: [PATCH]IB/ehca:reject dynamic memory add/remove
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Stefan Roscher <stefan.roscher@vnet.de.ibm.com>
Cc: Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       Roland Dreier <rolandd@cisco.com>, general@lists.openfabrics.org,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, hnguyen@de.ibm.com
In-Reply-To: <200810141423.48111.stefan.roscher@vnet.de.ibm.com>
References: <200810131310.34413.ossrosch@linux.vnet.ibm.com>
	 <1223917766.29877.17.camel@nimitz>
	 <200810141423.48111.stefan.roscher@vnet.de.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 05:29:13 -0700
Message-Id: <1223987353.29877.40.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 14:23 +0200, Stefan Roscher wrote:
> On Monday 13 October 2008 07:09:26 pm Dave Hansen wrote:
> > On Mon, 2008-10-13 at 13:10 +0200, Stefan Roscher wrote:
> > > Since the ehca device driver does not support dynamic memory add and remove
> > > operations, the driver must explicitly reject such requests in order to prevent
> > > unpredictable behaviors related to memory regions already occupied and being
> > > used by InfiniBand applications.
> > > The solution is to add a memory notifier to the ehca device driver and if a request
> > > for dynamic memory add or remove comes in, ehca will always reject it.
> > 
> > Why doesn't the driver support it?
> > 
> > This seems like an awfully extreme action to take.  Do you have plans to
> > support this in the driver soon?
> > 
> There is currently a slight incompatibility how openfabrics uses MRs
> and how System p does DMEM add/remove, which basically disables this
> support.
> If you want to talk to the firmware developpers, I can give you the right contacts.

I wish I knew what an 'MR' is. :(

Could you be a bit more specific so we can get a better changelog?
Perhaps if we understand the situation better, we can come up with a
better solution.

Does this have anything in common with the problems with 16GB pages?

-- Dave

