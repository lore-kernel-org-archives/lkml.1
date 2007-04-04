Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbXDDRi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbXDDRi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXDDRi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:38:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55752 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXDDRi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:38:58 -0400
Date: Wed, 4 Apr 2007 12:38:56 -0500
To: David Woodhouse <dwmw2@infradead.org>
Cc: Brad Boyer <flar@allandria.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404173856.GU4922@austin.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org> <20070403221002.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org> <20070403230908.GA13471@cynthia.pants.nu> <20070404162234.GS4922@austin.ibm.com> <1175704494.2774.33.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175704494.2774.33.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 12:34:53PM -0400, David Woodhouse wrote:
> On Wed, 2007-04-04 at 11:22 -0500, Linas Vepstas wrote:
> > The biggest problem would seem to be that the assignment would
> > depend on the detection order; there don't seem to be unique 
> > id's that would help udev consistently assign device names in 
> > consistent order. 
> 
> Of course there are. The different types of ports have different device
> numbers. As long as we don't do anything silly like putting all the
> serial drivers on the same major number, we can tell them apart
> relatively well.

Sure, but if two different pci serial cards are moved around  
to different pci slots, they'll be detected in a different order. 
Similarly if one has some usb-to-serial converter that might get
plugged in after boot, or maybe some serial port that shows up
only when a laptop is docked into a docking station.

--linas
