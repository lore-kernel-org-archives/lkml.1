Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYLASNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYLASNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYLASNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:13:41 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:26875 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYLASNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:13:40 -0500
Date: Mon, 1 Dec 2008 10:12:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Remi Colinet <remi.colinet@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org, linux-api@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Message-Id: <20081201101245.0a2f3123.randy.dunlap@oracle.com>
In-Reply-To: <20081129234907.GA2340@kroah.com>
References: <1227980689.6354.24.camel@localhost.localdomain>
	<20081129214207.GA6747@x200.localdomain>
	<20081129234907.GA2340@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49342921.000B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 15:49:07 -0800 Greg KH wrote:

> On Sun, Nov 30, 2008 at 12:42:07AM +0300, Alexey Dobriyan wrote:
> > On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> > > This patch add a new /proc/mempool file in order to display mempool usage.
> > > 
> > > The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> > > configuration.
> > 
> > We're NOT adding config option per proc file.
> > 
> > And can we, please, freeze /proc for not per-process stuff and open debugfs
> > for random stuff, please?
> 
> debugfs has been open for random stuff since the day it was added to the
> tree :)
> 
> Feel free to put this kind of thing there instead of proc.

Do distros ship with debugfs enabled?
The problem with using debugfs is that it is very optional IMO.

---
~Randy
