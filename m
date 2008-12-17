Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752517AbYLQUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYLQUHw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYLQUHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:07:38 -0500
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:43105 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751276AbYLQUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:07:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=QOgxZmIs5l1iZZx39ff9lAVtLf1fRcD9yX3W9vQ4OAPtM32+5nNacv3ZSesfx9OCWl3rSuE6ZPZubHtJTFD5M9kau2CVe9jsHDZMRUvO9O2+lJwxV5UcmIzddLxa4TJ/;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Date: Wed, 17 Dec 2008 12:07:32 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: "Rose, Gregory V" <gregory.v.rose@intel.com>,
        Jike Song <albcamus@gmail.com>, "Zhao, Yu" <yu.zhao@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "achiang@hp.com" <achiang@hp.com>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812171142.56170.jbarnes@virtuousgeek.org> <20081217195143.GA25211@kroah.com>
In-Reply-To: <20081217195143.GA25211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171207.34396.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2008 11:51 am Greg KH wrote:
> On Wed, Dec 17, 2008 at 11:42:54AM -0800, Jesse Barnes wrote:
> > I really don't want the SR-IOV stuff to sit out another merge cycle
> > though... Arg.
>
> Why, is there some rush to get it in?  As there is no in-kernel users of
> it, I don't see the problem with postponing it until someone actually
> needs it.

Well it *does* make development of SR-IOV drivers that much harder.  As you 
know, out of tree development is a pain.  OTOH if any changes end up being 
required, they can be done before the code is merged.

Anyway, hopefully we won't have to worry about it because some driver will 
come along soon that uses Yu's code. :)  If not, Yu might have to maintain a 
separate git tree or something until the drivers are ready to be merged.

-- 
Jesse Barnes, Intel Open Source Technology Center

