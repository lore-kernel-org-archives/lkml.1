Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbYJVFEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbYJVFEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYJVFEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:04:20 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:27659 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYJVFET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:04:19 -0400
X-Greylist: delayed 991 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 01:04:19 EDT
Date: Tue, 21 Oct 2008 21:47:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh <greg@kroah.com>
Subject: Re: linux-next: Tree for October 21 (staging/prism2-usb)
Message-Id: <20081021214720.a1ff0096.randy.dunlap@oracle.com>
In-Reply-To: <20081021195109.ed83b102.sfr@canb.auug.org.au>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.48FEB060.0267:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 19:51:09 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Today's tree will not build for powerpc allyesconfig (libc aborts the
> link due to a free() problem), sparc(32) defconfig and probably some
> other configurations.
> 
> I am no longer commenting on conflicts that are clearly just caused by
> slight differences in what has been merged into Linus' tree and
> linux-next or conflicts caused by further changes in the linux-next after
> a subset of a tree has been merged.


ERROR: "wireless_send_event" [drivers/staging/wlan-ng/p80211.ko] undefined!

Looks like that driver should depend on WIRELESS or slt (something like that).

---
~Randy
