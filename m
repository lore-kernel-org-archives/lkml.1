Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752486AbYLQTG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbYLQTG1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYLQTGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:06:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:3303 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYLQTGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:06:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,238,1228118400"; 
   d="scan'208";a="474833977"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Greg KH <greg@kroah.com>, Jike Song <albcamus@gmail.com>,
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
Date: Wed, 17 Dec 2008 11:05:54 -0800
Subject: RE: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Index: AclgeI/VIze9GOb0RNK0srF1wFfd9QAAM/Kg
Message-ID: <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
 <20081217060608.GA12618@kroah.com>
 <43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
 <200812171051.36645.jbarnes@virtuousgeek.org>
In-Reply-To: <200812171051.36645.jbarnes@virtuousgeek.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 

On Wednesday, December 17, 2008 8:44 am Rose, Gregory V wrote:
> As noted in the attached email to the netdev list, we (e1000_devel) will
> support the API.

Do you think you'll have those changes ready for 2.6.29?  Would merging core
SR-IOV support now make that any more likely?

>>>>>>>>>

I'm not sure about readiness for 2.6.29.  I can tell you that as soon as I get a Xen Dom0 kernel with these API's included it will take me less than a day to convert over to them from the current drivers I have that are using an older API from back in August.  The drivers are mostly functional, they have a few bugs.  I could do some quick regression testing to make sure that the API changes haven't broken anything and then some bug fixes to get everything ready for release.  Maybe two or three weeks for the major bugs.  I'll be out over the Christmas holidays so that puts us into middle or late January if I got the Xen Dom0 kernel today.  That seems unlikely but it gives you an idea of the time required.

- Greg

