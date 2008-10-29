Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYJ2J4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYJ2J4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYJ2Jz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:55:57 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5062 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJ2Jz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:55:56 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K9HVKE-03-H0M-01
Date: Wed, 29 Oct 2008 10:55:25 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: Ingo Molnar <mingo@elte.hu>, Jouni Malinen <jkmalinen@gmail.com>,
       Oliver Neukum <oliver@neukum.org>, Nicolas Bareil <nico@chdir.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] x86, gart: fix gart detection for Fam11h CPUs
Message-ID: <20081029095525.GA6345@amd.com>
References: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com> <1225206834-6189-1-git-send-email-joerg.roedel@amd.com> <20081028165236.GA4503@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081028165236.GA4503@kroah.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Oct 2008 09:55:25.0937 (UTC) FILETIME=[77889E10:01C939AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 09:52:36AM -0700, Greg KH wrote:
> On Tue, Oct 28, 2008 at 04:13:54PM +0100, Joerg Roedel wrote:
> > The AMD Fam11h CPUs have a K8 northbridge. This northbridge is different
> > from other familys because it lacks GART support (as I just learned).
> > But the kernel implicitly expects a GART if it finds an AMD northbridge.
> > Fix this by removing the Fam11h northbridge id from the scan list of K8
> > northbridges. This patch also changes the message in the GART driver
> > about missing K8 northbridges to tell that the GART is missing which is
> > the correct information in this case.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Looks like this needs to be added to the 2.6.27-stable tree also, right?

No, this patch not. The PCI id was added during the .28 merge window.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

