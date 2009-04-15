Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZDOBSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZDOBSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZDOBSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:18:09 -0400
Received: from kroah.org ([198.145.64.141]:54342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752709AbZDOBSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:18:07 -0400
Date: Tue, 14 Apr 2009 18:06:45 -0700
From: Greg KH <greg@kroah.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "subrata@linux.vnet.ibm.com" <subrata@linux.vnet.ibm.com>,
       "James P. Ketrenos" <ipw2100-admin@linux.intel.com>,
       Andrea Merello <andreamrl@tiscali.it>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-next <linux-next@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Ipw2100-admin] [BUILD FAILURE 04/12] Next April 14 : PPC64
	randconfig [drivers/staging/built-in.o]
Message-ID: <20090415010645.GA10045@kroah.com>
References: <1239733717.5344.76.camel@subratamodak.linux.ibm.com> <1239735595.15115.60.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239735595.15115.60.camel@rc-desk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:59:55AM -0700, reinette chatre wrote:
> Hi Subrata,
> 
> On Tue, 2009-04-14 at 11:28 -0700, Subrata Modak wrote:
> > Observed the following build error:
> > ---
> > LD      drivers/built-in.o
> > drivers/staging/built-in.o: In function `ieee80211_xmit':
> > drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c:528: multiple
> > definition of `ieee80211_xmit'
> > drivers/net/built-in.o:drivers/net/wireless/ipw2x00/libipw_tx.c:256:
> > first defined here
> > make[1]: *** [drivers/built-in.o] Error 1
> > make: *** [drivers] Error 2
> 
> Looks like the rtl8187se driver started with a copy of ipw2x00's
> library. Errors like this can thus be expected and should be addressed
> by rtl8187se as they are the ones who made the copy.

Yes, at this point in time, don't build the staging drivers into the
kernel, it's not advised at all.

thanks,

greg k-h
