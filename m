Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbXCHEkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbXCHEkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXCHEkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:40:33 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47546 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbXCHEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:40:32 -0500
Date: Thu, 8 Mar 2007 10:10:13 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Arjan van de Ven <arjan@infradead.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: Re: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
Message-ID: <20070308044013.GE6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <1173280059.3540.5.camel@laptopd505.fenrus.org> <1173300597.3219.105.camel@nigel.suspend2.net> <1173309302.13442.0.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173309302.13442.0.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 10:15:02AM +1100, Nigel Cunningham wrote:
> Hi.
> 
> On Thu, 2007-03-08 at 07:49 +1100, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Wed, 2007-03-07 at 07:07 -0800, Arjan van de Ven wrote:
> > > On Wed, 2007-03-07 at 12:27 +0530, Vivek Goyal wrote:
> > > > Hi,
> > > > 
> > > > Here is another attempt on x86_64 relocatable bzImage patches(V4). This
> > > > patchset makes a bzImage relocatable and same kernel binary can be loaded
> > > > and run from different physical addresses.
> > > 
> > > 
> > > have these patches been extensively tested with various suspend
> > > scenarios? (S1,S3,S4 in acpi speak or s2ram and s2disk in Linux speak)
> > 
> > We did work on this for RHEL5, getting relocatable kernel support
> > working fine with S4. While doing it and since, I've been running
> > Suspend2 with the same patch.
> > 
> > Since that work, Vivek has done more modifications, but I can confirm
> > that the basic design is reliable with S4. Haven't tried S3, but can do.
> > Will report back shortly.
> 
> S3 works okay here with a relocatable x86_64 kernel (2.6.20).
> 

Hi Nigel,

Is it possible to test S3 with 2.6.21-rc2 kernels also. Right now I don't 
have access to any machine supporting S3. I tested it at the time of my last
posting and it had worked well. Appreciate your help.

Thanks
Vivek
