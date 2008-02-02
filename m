Return-Path: <linux-kernel-owner+w=401wt.eu-S933824AbYBBUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbYBBUGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764570AbYBBUF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:05:56 -0500
Received: from ns.suse.de ([195.135.220.2]:59877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764120AbYBBUFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:05:54 -0500
Date: Sat, 2 Feb 2008 12:04:06 -0800
From: Greg KH <gregkh@suse.de>
To: Olof Johansson <olof@lixom.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, git-commits-head@vger.kernel.org
Subject: Re: [PATCH] Fix fallout from PCI: PCIE ASPM support
Message-ID: <20080202200406.GB24717@suse.de>
References: <200802020506.m1256gXG027547@hera.kernel.org> <20080202052628.GB14936@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202052628.GB14936@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 11:26:28PM -0600, Olof Johansson wrote:
> On Sat, Feb 02, 2008 at 05:06:42AM +0000, Linux Kernel Mailing List wrote:
> 
> >     PCI: PCIE ASPM support
> 
> This one broke almost all defconfigs on powerpc, since they enable
> CONFIG_EXPERIMENTAL and CONFIG_PCI, and this option defaults to y.
> 
> Make it default to 'n' like most other options, and make it depend on
> ACPI. Take out the unneccessary default 'n' from the debug option as well.
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

I'm just going to revert this, it's caused too many problems, sorry.

greg k-h
