Return-Path: <linux-kernel-owner+w=401wt.eu-S2992559AbXCGUt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992559AbXCGUt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992560AbXCGUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:49:57 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:45641 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992559AbXCGUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:49:56 -0500
Subject: Re: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Arjan van de Ven <arjan@infradead.org>
Cc: vgoyal@in.ibm.com,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
In-Reply-To: <1173280059.3540.5.camel@laptopd505.fenrus.org>
References: <20070307065703.GA23412@in.ibm.com>
	 <1173280059.3540.5.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 07:49:57 +1100
Message-Id: <1173300597.3219.105.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-03-07 at 07:07 -0800, Arjan van de Ven wrote:
> On Wed, 2007-03-07 at 12:27 +0530, Vivek Goyal wrote:
> > Hi,
> > 
> > Here is another attempt on x86_64 relocatable bzImage patches(V4). This
> > patchset makes a bzImage relocatable and same kernel binary can be loaded
> > and run from different physical addresses.
> 
> 
> have these patches been extensively tested with various suspend
> scenarios? (S1,S3,S4 in acpi speak or s2ram and s2disk in Linux speak)

We did work on this for RHEL5, getting relocatable kernel support
working fine with S4. While doing it and since, I've been running
Suspend2 with the same patch.

Since that work, Vivek has done more modifications, but I can confirm
that the basic design is reliable with S4. Haven't tried S3, but can do.
Will report back shortly.

Regards,

Nigel

