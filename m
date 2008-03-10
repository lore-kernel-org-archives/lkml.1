Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYCJPDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYCJPDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYCJPCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:02:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYCJPCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:02:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan McDowell <noodles@earth.li>
Subject: Re: 2.6.25 regression/oops on boot (ACPI related?)
Date: Mon, 10 Mar 2008 16:01:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Zhang, Rui" <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ming.m.lin@intel.com,
       Len Brown <lenb@kernel.org>
References: <20080228200855.GJ9009@earth.li> <20080301152706.GO9009@earth.li> <20080310143709.GM9009@earth.li>
In-Reply-To: <20080310143709.GM9009@earth.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101601.34169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of March 2008, Jonathan McDowell wrote:
> On Sat, Mar 01, 2008 at 03:27:06PM +0000, Jonathan McDowell wrote:
> > On Fri, Feb 29, 2008 at 07:38:54AM +0800, Zhang, Rui wrote:
> > > On Fri, 2008-02-29 at 15:54 +0800, Jonathan McDowell wrote:
> > > > On Fri, Feb 29, 2008 at 01:20:27AM +0800, Zhang, Rui wrote:
> > > > > Please attach the acpidump output using the latest pmtools at :
> > > > > http://www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/
> > > > > Please attach the result of "cat /proc/acpi/thermal_zone/*/*" as
> > > > well.
> > > > 
> > > > I've attached the output of acpidump. The cat results in this output:
> > > > 
> > > > [noodles@meepok /proc/acpi/thermal_zone/THRM]$ cat *
> > > > 0 - Active; 1 - Passive
> > > > <polling disabled>
> > > > state:                   ok
> > > > temperature:             40 C
> > > > Segmentation fault
> > > > 
> > > > It also causes a general protection fault, which I've attached as
> > > > well.
> > > > 
> > > > This is a stock Debian kernel:
> > > > 
> > > > Linux meepok 2.6.24-1-amd64 #1 SMP Mon Feb 11 13:47:43 UTC 2008 x86_64
> > > > GNU/Linux
> > > > 
> > > > I have a patch from Ming Lin to try out but it'll have to wait until
> > > > tomorrow before I can do so.
> > > > 
> > > We've root caused the problem and Lin Ming's patch should work for you.
> > > Please give it a try. :)
> > 
> > I've now done so; it fixes my problem and 2.6.25-rc3 boots fine with it
> > applied. Thanks.
> 
> Is there a reason this still hasn't made it into 2.6.25-rc5?

Well, I guess Len was unaware of it (CCed now).

Thanks,
Rafael
