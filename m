Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279Ab0ALSTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0ALSTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067Ab0ALSTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:19:08 -0500
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:45415 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753865Ab0ALSTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:19:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XhuP8hHN40ZyASb6W59AvWp24okrRVNbimXr22iLowCywvHnDhBu3ihWn8sU7eSAJLxaEnqG11iPfXQg0lvKacUXs4gKugZALxPOzW/bSvPgNoX5ZmeOgGJcbvnfRYLy;
Date: Tue, 12 Jan 2010 10:18:59 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: patrick.keller@hp.com
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Chiang, Alexander" <achiang@hp.com>,
       "Helgaas, Bjorn" <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 00/14] pci: update pci bridge resources
Message-ID: <20100112101859.1a6b5a4c@jbarnes-piketon>
In-Reply-To: <1263247020.2877.10.camel@pLaptop>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1263247020.2877.10.camel@pLaptop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 14:57:00 -0700
Patrick Keller <patrick.keller@hp.com> wrote:

> 
> 
> On Tue, 2009-12-22 at 23:02 +0000, Yinghai Lu wrote:
> 
> > 2. hotplug:
> > BIOS separate IO range between several IOHs, and on some slots,
> > BIOS assign the resource to every bridge. (8M) but when insert one
> > card that big resource, the card can not get resource. because
> > kernel will not touch the bridge resource.
> 
> > Thanks
> > 
> > Yinghai
> > 
> 
> These patches appear to fix logical hotplug so that it is functional
> again.  I think we're good.
> 
> Tested-by: Patrick Keller <patrick.keller@hp.com>

Thanks Patrick, I'll check them out and start applying.

-- 
Jesse Barnes, Intel Open Source Technology Center
