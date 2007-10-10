Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbXJJPjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbXJJPjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbXJJPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:38:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48261 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754072AbXJJPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:38:53 -0400
Date: Wed, 10 Oct 2007 11:38:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Tejun Heo <htejun@gmail.com>, <ebiederm@xmission.com>,
       <cornelia.huck@de.ibm.com>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
 model
In-Reply-To: <20071009224820.GE21228@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0710101135240.4792-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Greg KH wrote:

> The rules for sysfs files are the following:
> 	- one value, in text format, per file.
> 	- no action apon open/close
> 	- binary files are only allowed for "pass-through" type files
> 	  that the kernel does not touch (like for firmware and pci
> 	  config space)
> 	- directories should be associated with a kobject where it makes
> 	  sense (no nesting deep subdirectories without a kobject
> 	  present)

You have to stretch this a little for the power/ subdirectory every 
device gets.  The only kobject it corresponds to is the one in the 
device, which already corresponds to the parent directory.

Alan Stern

