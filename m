Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZA0XhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZA0XhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZA0XhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:37:06 -0500
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:48539 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751545AbZA0XhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:37:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=a8biOGa/ni4bhnzIZchermcAuXrG6QIhn9/rbNeM7PzFBNBXJmbU+d1X7XstyoLuo9Eo7vuA2sBblLAAUgo/72BE9tdvoT2/Fz1yawrVOIQdCknalLOspcCc2sN9Yj+c;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] pcie hotplug: Change link order of pciehp
Date: Tue, 27 Jan 2009 15:37:00 -0800
User-Agent: KMail/1.9.10
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-pci@vger.kernel.org,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
References: <20090127003743.GA27711@srcf.ucam.org> <20090127010335.GA29035@srcf.ucam.org> <497E6EDA.2050700@oracle.com>
In-Reply-To: <497E6EDA.2050700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271537.00957.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2009 6:18 pm Randy Dunlap wrote:
> Matthew Garrett wrote:
> > commit bf53d46d80486fa613dc345aba5d42a29368056d
> > Author: Matthew Garrett <mjg@redhat.com>
> > Date:   Tue Jan 27 11:29:02 2009 +1100
> >
> > pcie hotplug: Change link order of pciehp
> >
> > Some hardware exposes PCIE slots in such a way that they can be claimed
> > by either the acpiphp or pciehp driver. pciehp is the preferred driver if
> > the firmware allows the OS to claim control via the _OSC method so should
> > be loaded first - if it fails to bind (either due to a missing _OSC
> > method or the firmware refusing to hand off control) then we can fall
> > back to acpiphp or a vendor-specific driver.
> >
> > This patch simply changes the link order to ensure that pciehp will be
> > initialised before acpiphp if both are statically built into the kernel.
> >
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Ok, applied to my for-linus branch, since this is actually affecting users 
now.

-- 
Jesse Barnes, Intel Open Source Technology Center
