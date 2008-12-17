Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752814AbYLQTnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYLQTnd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYLQTnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:43:03 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:33774 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751951AbYLQTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:43:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Q4gy/UclDCp86V5ng+pXJZX2n7sqAJoLTRaMb3LWv4muk5N/tnNw7kNN1qu+CQpObxZq/gIMyj99/upAy/3Ppp/4Lc6A0oeoSUjE50pjhSPbEPeyh34cO6heznivTcoA;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Date: Wed, 17 Dec 2008 11:42:54 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Jike Song <albcamus@gmail.com>,
        "Zhao, Yu" <yu.zhao@intel.com>,
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
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812171051.36645.jbarnes@virtuousgeek.org> <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171142.56170.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2008 11:05 am Rose, Gregory V wrote:
> -----Original Message-----
> From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org]
>
> On Wednesday, December 17, 2008 8:44 am Rose, Gregory V wrote:
> > As noted in the attached email to the netdev list, we (e1000_devel) will
> > support the API.
>
> Do you think you'll have those changes ready for 2.6.29?  Would merging
> core SR-IOV support now make that any more likely?
>
>
>
> I'm not sure about readiness for 2.6.29.  I can tell you that as soon as I
> get a Xen Dom0 kernel with these API's included it will take me less than a
> day to convert over to them from the current drivers I have that are using
> an older API from back in August.  The drivers are mostly functional, they
> have a few bugs.  I could do some quick regression testing to make sure
> that the API changes haven't broken anything and then some bug fixes to get
> everything ready for release.  Maybe two or three weeks for the major bugs.
>  I'll be out over the Christmas holidays so that puts us into middle or
> late January if I got the Xen Dom0 kernel today.  That seems unlikely but
> it gives you an idea of the time required.

Hm, that's not the answer I was hoping for. :)  (Was looking for, "Yeah we 
just need this bits queued and we'll send an update for e1000 right away." :)

I really don't want the SR-IOV stuff to sit out another merge cycle though...  
Arg.

-- 
Jesse Barnes, Intel Open Source Technology Center

