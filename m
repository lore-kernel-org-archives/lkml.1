Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbYBMJcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbYBMJcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYBMJcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:32:33 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:57616 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYBMJcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:32:31 -0500
Date: Wed, 13 Feb 2008 11:32:26 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: jdmason@kudzu.us, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213093225.GA16985@rhun.haifa.ibm.com>
References: <20080213001506.GA13933@kroah.com> <20080213001638.GB13933@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213001638.GB13933@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:16:38PM -0800, Greg KH wrote:

> Why does the calgary driver need this?  Can we just use
> pci_get_device() instead?  Why do you need to walk the device list
> backwards?  Do you get false positives going forward?

It's not strictly needed, we used it for symmetry. Feel free to nuke
it and walk the list forward.

Cheers,
Muli
