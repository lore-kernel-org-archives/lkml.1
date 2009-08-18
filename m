Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZHRMYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZHRMYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbZHRMYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:24:54 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:22532 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZHRMYy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;5:2>);
	Tue, 18 Aug 2009 08:24:54 -0400
Message-Id: <4A8A65540200005A000528EA@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 Beta 
Date: Tue, 18 Aug 2009 06:24:52 -0600
From: "Gregory Haskins" <GHaskins@novell.com>
To: <avi@redhat.com>
Cc: <mingo@elte.hu>, <gregory.haskins@gmail.com>,
       <alacrityvm-devel@lists.sourceforge.net>, <mst@redhat.com>,
       <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model	 for
References: <4A8A654A0200005A000528E7@sinclair.provo.novell.com>
 <4A8A65540200005A000528EA@sinclair.provo.novell.com>
In-Reply-To: <4A8A65540200005A000528EA@sinclair.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Again on the top post)

No, Avi, nothing has changed to my knowledge.  I just saw that you and Michael were heading down the same path, so I thought I might interject that we've already covered that ground.

As of right now, I am of the opinion that its not worth any change in the short term, and may be worth IOoHC in the long term (primarily so that mmios get a boost)

-greg.
 
-----Original Message-----
From: Avi Kivity <avi@redhat.com>
To: Gregory Haskins <GHaskins@novell.com>
Cc:  <mingo@elte.hu>
Cc:  <gregory.haskins@gmail.com>
Cc:  <alacrityvm-devel@lists.sourceforge.net>
Cc:  <mst@redhat.com>
Cc:  <kvm@vger.kernel.org>
Cc:  <linux-kernel@vger.kernel.org>
Cc:  <netdev@vger.kernel.org>

Sent: 8/18/2009 6:19:53 AM
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model	 for	vbus_drive

On 08/18/2009 03:11 PM, Gregory Haskins wrote:
> Sorry for the toppost.  Still not at the office.
>
> I just wanted to add that we've already been through this disussion once.  (Search "haskins hypercall lkml" on google and I'm sure you are bound to see hits.
>
>    

Your numbers showed a 350ns difference on fairly old (by now) hardware.  
I doubt the difference will exceed 200ns now.

> The fact is: the original vbus was designed with hypercalls, and it drew much of these same critisims.  In the end, hypercalls are only marginally faster than PIO (iirc, 450ns faster, and shrinking), so we decided that it was not worth further discussion at the time.
>    

Has anything changed?

> A better solution is probably PIOoHC, so that you retain the best properties of both.  The only problem with the entire PIOx approach is that its x86 specific, but that is an entirely different thread.
>    

pio is nicely abstracted by PCI.  virtio-pci will use pio on x86 and 
mmio on non-x86.

-- 
error compiling committee.c: too many arguments to function


