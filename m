Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbXFLD0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbXFLD0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXFLD0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:26:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXFLD0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:26:01 -0400
Date: Mon, 11 Jun 2007 23:25:53 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
Message-ID: <20070612032553.GB19293@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
	linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20070609000827.GA17624@kroah.com> <963615.80973.qm@web50105.mail.re2.yahoo.com> <20070611234947.GA20078@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611234947.GA20078@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 04:49:47PM -0700, Greg Kroah-Hartman wrote:
 > On Mon, Jun 11, 2007 at 04:30:11PM -0700, Doug Thompson wrote:
 > > I am working with the k8 driver and its dealing with a race with the mcelog device as both access
 > > the K8 NB. The K8 driver does use these regs and it currently has #ifndef s in it for both of
 > > them.
 > > 
 > > I guess I could have submitted the patch when the K8 driver was submitted.
 > 
 > That would be preferable, thanks.

Even better (IMO), if they're not used by any other driver (which seems
to be the case), keep the defines local to the driver.

	Dave

-- 
http://www.codemonkey.org.uk
