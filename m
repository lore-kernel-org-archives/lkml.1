Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYJWVhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYJWVhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYJWVhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:37:04 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:53874 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752944AbYJWVhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:37:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rOS9t1x4wviQbTTXywDLv1bszpm9Yd5TiASbGpejBXj3AHxyxVc5NsGGHeokRHngiHXoh95MislFJG3vo9aqz1NqXMBBGacHP1BWUNRlinvb4/BhVYlPi97Zj+1P9fCz;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [BUG][PATCH] cpqphp: fix kernel NULL pointer dereference
Date: Thu, 23 Oct 2008 14:36:43 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48F7DB17.9020302@jp.fujitsu.com> <20081017003334.GA28723@ldl.fc.hp.com> <20081023203732.GA17600@kroah.com>
In-Reply-To: <20081023203732.GA17600@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231436.44308.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2008 1:37 pm Greg KH wrote:
> On Thu, Oct 16, 2008 at 06:33:34PM -0600, Alex Chiang wrote:
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > > The root cause of this problem seems that cpqphp driver calls
> > > pci_hp_register() wrongly. In current implementation, cpqphp driver
> > > passes 'ctrl->pci_dev->subordinate' as a second parameter for
> > > pci_hp_register(). But because hotplug slots and it's hotplug
> > > controller (exists as a pci funcion) are on the same bus, it should be
> > > 'ctrl->pci_dev->bus' instead.
> > >
> > > Cc: <stable@kernel.org>
> >
> > Acked-by: Alex Chiang <achiang@hp.com>
>
> This patch doesn't seem to have made it upstream.
>
> Jesse, is it queued up in any of your trees?

No I missed it initially.  I've got it queued up now though.

Jesse
