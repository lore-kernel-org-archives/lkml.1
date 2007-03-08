Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbXCHDgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbXCHDgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXCHDgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:36:49 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50569 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXCHDgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:36:48 -0500
Date: Thu, 8 Mar 2007 09:06:06 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: Re: [PATCH 0/20] x86_64 Relocatable bzImage support (V4)
Message-ID: <20070308033606.GA6000@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com> <1173280059.3540.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173280059.3540.5.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 07:07:39AM -0800, Arjan van de Ven wrote:
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

Hi Arjan,

I have tested these patches for suspend to RAM and suspend to disk and they
work fine. In the past we had few issues with suspend to disk and now
these issues have been resolved in this patchset. 

Thanks
Vivek

