Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0CCRfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:35:23 -0500
Received: from claw.goop.org ([74.207.240.146]:41165 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab0CCRfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:35:22 -0500
Message-ID: <4B8E9DD7.6020408@goop.org>
Date: Wed, 03 Mar 2010 09:35:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of  HVM initialization
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>  <1267436315-24486-4-git-send-email-sheng@linux.intel.com>  <4B8C63B0.2090507@goop.org>  <201003020938.53630.sheng@linux.intel.com> <1267521735.11737.23107.camel@zakaz.uk.xensource.com> <4B8D7248.5070807@goop.org> <alpine.DEB.2.00.1003031132550.4648@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003031132550.4648@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 03:35 AM, Stefano Stabellini wrote:
> Give a look at the fourth patch of the series I just posted: it
> introduces a simple driver for the Xen PCI platform device to initialize
> xenbus and gran table later on when running in a HVM domain, at the same
> time leaving the PV case as it is.
>    

Yes, I noticed that.  Do the PV drivers cope with having the PCI 
probe/xenbus setup after their init functions have been called, or do 
you make sure the PCI probe happens early?

     J
