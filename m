Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYIPXCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYIPXCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYIPXCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:02:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYIPXCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:02:10 -0400
Date: Tue, 16 Sep 2008 19:01:44 -0400
From: Rik van Riel <riel@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: "Michael Chan" <mchan@broadcom.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5-mm1
Message-ID: <20080916190144.46f534b4@bree.surriel.com>
In-Reply-To: <20080916140917.105adc2a@bree.surriel.com>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
	<20080915180130.10995b90@cuia.bos.redhat.com>
	<1221519658.11021.13.camel@HP1>
	<20080916140917.105adc2a@bree.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 14:09:17 -0400
Rik van Riel <riel@redhat.com> wrote:
> On Mon, 15 Sep 2008 16:00:58 -0700
> "Michael Chan" <mchan@broadcom.com> wrote:
> 
> > > 05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > > 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > 
> > Does dmesg show anything when you run ifup?
>  
> The linux-next tree fails in the same way.  Here is the dmesg output
> from the broadcom driver:

OK, with pci=nomsi the system boots up fine and the bnx2 driver
works.

Looks like the MSI code in linux-next is broken on the Dell PE 1950.

-- 
All rights reversed.
