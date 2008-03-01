Return-Path: <linux-kernel-owner+w=401wt.eu-S1761736AbYCAP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761736AbYCAP1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYCAP1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:27:10 -0500
Received: from the.earth.li ([217.147.81.2]:40285 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbYCAP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:27:09 -0500
Date: Sat, 1 Mar 2008 15:27:06 +0000
From: Jonathan McDowell <noodles@earth.li>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       ming.m.lin@intel.com
Subject: Re: 2.6.25 regression/oops on boot (ACPI related?)
Message-ID: <20080301152706.GO9009@earth.li>
References: <20080228200855.GJ9009@earth.li> <1204219227.10256.146.camel@acpi-hp-zz.sh.intel.com> <20080229075449.GK9009@earth.li> <1204241934.10256.151.camel@acpi-hp-zz.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204241934.10256.151.camel@acpi-hp-zz.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 07:38:54AM +0800, Zhang, Rui wrote:
> On Fri, 2008-02-29 at 15:54 +0800, Jonathan McDowell wrote:
> > On Fri, Feb 29, 2008 at 01:20:27AM +0800, Zhang, Rui wrote:
> > > Please attach the acpidump output using the latest pmtools at :
> > > http://www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/
> > > Please attach the result of "cat /proc/acpi/thermal_zone/*/*" as
> > well.
> > 
> > I've attached the output of acpidump. The cat results in this output:
> > 
> > [noodles@meepok /proc/acpi/thermal_zone/THRM]$ cat *
> > 0 - Active; 1 - Passive
> > <polling disabled>
> > state:                   ok
> > temperature:             40 C
> > Segmentation fault
> > 
> > It also causes a general protection fault, which I've attached as
> > well.
> > 
> > This is a stock Debian kernel:
> > 
> > Linux meepok 2.6.24-1-amd64 #1 SMP Mon Feb 11 13:47:43 UTC 2008 x86_64
> > GNU/Linux
> > 
> > I have a patch from Ming Lin to try out but it'll have to wait until
> > tomorrow before I can do so.
> > 
> We've root caused the problem and Lin Ming's patch should work for you.
> Please give it a try. :)

I've now done so; it fixes my problem and 2.6.25-rc3 boots fine with it
applied. Thanks.

J.

-- 
Programmer, |   101 things you can't have too    |       Tel/SMS:
sysadmin &  |        much of : 51 - News.        |   +423-663-212343
BHMF.       |                                    |  Made by HuggieTag
