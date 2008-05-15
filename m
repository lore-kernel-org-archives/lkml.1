Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYEOOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYEOOOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYEOOOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:14:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58511 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753233AbYEOOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:14:01 -0400
Date: Thu, 15 May 2008 10:14:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Huang, Ying" <ying.huang@intel.com>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <m13aok1pt1.fsf@frodo.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0805151012150.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Eric W. Biederman wrote:

> My take on the situation is this.  For proper handling we
> need driver device_detach and device_reattach methods.
> 
> With the following semantics.  The device_detach methods
> will disable DMA and place the hardware in a sane state
> from which the device driver can reclaim and reinitialize it,
> but the hardware will not be touched.
> 
> device_reattach reattaches the driver to the hardware.

How would these differ from the already-existing remove and probe 
methods?

Alan Stern

