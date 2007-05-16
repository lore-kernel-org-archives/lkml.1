Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbXEPPpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbXEPPpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXEPPpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:45:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37921 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbXEPPpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:45:00 -0400
Date: Wed, 16 May 2007 08:44:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to force Kconfig tristate into range n..m?
Message-ID: <20070516154459.GA2060@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070515233002.GA9614@linux.vnet.ibm.com> <200705161418.49151.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705161418.49151.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 02:18:48PM +0200, Andi Kleen wrote:
> 
> >
> > Is there some other way to prohibit modules from being compiled into
> > the main kernel?
> 
> One way is to use a separate symbol that is not user visible, but depends
> on your main symbol and uses default m
> 
> (similar to the now infamous CONFIG_SCSI_WAIT_SCAN)

Cool!!!  Any problem you see with Randy Dunlap's suggestion of simply
adding "depends on m", though?

						Thanx, Paul
