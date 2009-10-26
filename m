Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZJZRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZJZRH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZJZRH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:07:26 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57611 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZJZRHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:07:25 -0400
Date: Mon, 26 Oct 2009 10:02:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-Id: <20091026100235.b6bf2df6.randy.dunlap@oracle.com>
In-Reply-To: <20091026164645.GD2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
	<20091020090627.f36130fb.randy.dunlap@oracle.com>
	<20091026164645.GD2792@tuxdriver.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AE5D740.0115:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 12:46:45 -0400 John W. Linville wrote:

> On Tue, Oct 20, 2009 at 09:06:27AM -0700, Randy Dunlap wrote:
> > On Tue, 20 Oct 2009 14:17:07 +0900 John W. Linville wrote:
> > 
> > > Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
> > > several years this driver has only seen API "bombing-run" changes, and
> > > few people ever had the hardware.  This driver represents unnecessary
> > > ongoing maintenance for no clear benefit.
> > > 
> > > This patch brought to you by the "hacking" session at the 2009 Kernel
> > > Summit in Tokyo, Japan...
> > 
> > is drivers/staging/ a temporary home or a permanent home?
> 
> I would presume it to be "permanent until removed"...
> 
> > so no explanation of what it means to be in drivers/staging/ and
> > no warning to users?  either in Kconfig or in feature-removal-schedule.txt?
> 
> Moving it to staging _is_ the warning.

Nah.  Maybe it is for developers, but not for users (IMO of course).

> As for the removal schedule,
> I imagined that Greg would "do the needful" before actually removing
> the driver.

He usually wants patches, but that's up to him.

---
~Randy
