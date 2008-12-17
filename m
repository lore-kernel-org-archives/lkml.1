Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758199AbYLQQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYLQQqU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758591AbYLQQob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:44:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:2418 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758530AbYLQQo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:44:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,238,1228118400"; 
   d="scan'208";a="371687688"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Greg KH <greg@kroah.com>, Jike Song <albcamus@gmail.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "Zhao, Yu" <yu.zhao@intel.com>,
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
Date: Wed, 17 Dec 2008 08:44:03 -0800
Subject: RE: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Index: AclgDaCoeYQYUlaJTeKdxyBTEPCJqwAWNMgg
Message-ID: <43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
 <200812161523.55238.jbarnes@virtuousgeek.org> <49486602.5000108@gmail.com>
 <20081217060608.GA12618@kroah.com>
In-Reply-To: <20081217060608.GA12618@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_43F901BD926A4E43B106BF17856F07554B525811orsmsx508amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_43F901BD926A4E43B106BF17856F07554B525811orsmsx508amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

As noted in the attached email to the netdev list, we (e1000_devel) will su=
pport the API.

- Greg Rose

-----Original Message-----
From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behal=
f Of Greg KH
Sent: Tuesday, December 16, 2008 10:06 PM
To: Jike Song
Cc: Jesse Barnes; Zhao, Yu; linux-pci@vger.kernel.org; achiang@hp.com; bjor=
n.helgaas@hp.com; grundler@parisc-linux.org; mingo@elte.hu; matthew@wil.cx;=
 randy.dunlap@oracle.com; rdreier@cisco.com; horms@verge.net.au; yinghai@ke=
rnel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; virtualization=
@lists.linux-foundation.org
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support

On Wed, Dec 17, 2008 at 10:37:54AM +0800, Jike Song wrote:
> Jesse Barnes wrote:
> > Given a respin of 10-13 I think it's reasonable to merge this into 2.6.=
29, but=20
> > I'd be much happier about it if we got some driver code along with it, =
so as=20
> > not to have an unused interface sitting around for who knows how many=20
> > releases.  Is that reasonable?  Do you know if any of the corresponding=
 PF/VF=20
> > driver bits are ready yet?
>=20
> Hi Jesse,=20
>=20
> Yu Zhao has posted a patch set with subject "SR-IOV driver example"=20
> at November 26, which illustrated the usage of SR-IOV API in Intel 82576 =
VF/PF
> drivers;-)

Yes, but that driver was soundly rejected by the network driver
maintainers, so I wouldn't go around showing that as your primary
example of how to use this interface :)

The point is valid, I don't think these apis should go into the tree
without a driver or some other code using them.  Otherwise they make no
sense at all to have in-tree.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe kvm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_002_43F901BD926A4E43B106BF17856F07554B525811orsmsx508amrcor_
Content-Type: message/rfc822

Received: from rrsmsx001.amr.corp.intel.com (10.31.0.150) by
 orsmsx603.amr.corp.intel.com (10.22.226.49) with Microsoft SMTP Server (TLS)
 id 8.1.291.1; Tue, 2 Dec 2008 19:12:35 -0800
Received: from rrsmsx411.amr.corp.intel.com (10.14.9.116) by
 rrsmsx001.amr.corp.intel.com (10.31.0.150) with Microsoft SMTP Server id
 8.1.240.5; Tue, 2 Dec 2008 20:12:34 -0700
Received: from azsmsx333.amr.corp.intel.com ([10.2.121.77]) by
 rrsmsx411.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830);	 Tue, 2
 Dec 2008 21:12:34 -0600
Received: from fmsmga002.fm.intel.com ([10.253.24.26]) by
 azsmsx333.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.3959);	 Tue, 2
 Dec 2008 20:12:19 -0700
Received: from fmsmga102.fm.intel.com ([10.1.193.69])  by
 fmsmga002-1.fm.intel.com with ESMTP; 02 Dec 2008 19:07:55 -0800
Received: from mail-gx0-f16.google.com ([209.85.217.16])  by mga11.intel.com
 with ESMTP; 02 Dec 2008 19:05:54 -0800
Received: by gxk9 with SMTP id 9so3840866gxk.1        for
 <gregory.v.rose@intel.com>; Tue, 02 Dec 2008 19:12:18 -0800 (PST)
Received: by 10.90.53.4 with SMTP id b4mr7067164aga.88.1228273938232;
        Tue, 02 Dec 2008 19:12:18 -0800 (PST)
Received: by 10.90.116.13 with HTTP; Tue, 2 Dec 2008 19:12:18 -0800 (PST)
From: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "greg@kroah.com"
	<greg@kroah.com>, "matthew@wil.cx" <matthew@wil.cx>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xensource.com"
	<xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Nakajima, Jun" <jun.nakajima@intel.com>, "Rose,
 Gregory V" <gregory.v.rose@intel.com>
Sender: "tarbal@gmail.com" <tarbal@gmail.com>
Date: Tue, 2 Dec 2008 19:12:18 -0800
Subject: Re: [SR-IOV driver example 0/3 resend] introduction
Thread-Topic: [SR-IOV driver example 0/3 resend] introduction
Thread-Index: AclU9P1ETlKqA/muTzqMDfhqyjYfvg==
Message-ID: <9929d2390812021912ua5ddeafo3ae4a5759ffc4c4e@mail.gmail.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
	 <20081202092741.GA1859@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081202092741.GA1859@yzhao12-linux.sh.intel.com>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: rrsmsx001.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originalarrivaltime: 03 Dec 2008 03:12:19.0681 (UTC)
 FILETIME=[F3DC1510:01C954F4]
domainkey-signature: a=rsa-sha1; c=nofws;        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IxnRuQwy6BoNr8tCH3S7MAx3RyGAmPYkE97itIoEW+nirbaY25kdnNpykrDsm1I79v
         iIO86qhiEft06xP1ky1dkr+IdbB72w8mz/L/6c7NOAE56CGU+jYh372C8bvchH6rpCKM
         OzwbAIceX2z2eWBn3bL7Tuq+5TaGjB8pCgnY4=
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed;        d=gmail.com;
 s=gamma;
        h=domainkey-signature:received:received:message-id:date:from:sender
         :to:subject:cc:in-reply-to:mime-version:content-type
         :content-transfer-encoding:content-disposition:references
         :x-google-sender-auth;
        bh=e9xNAQZZWFjlOV38DxIQonYmnlsdss0a2ZxG48LbqdA=;
        b=eFMyWYMUXL7VRkv0Yn65bPjzMRhDf+aOQc6MS/49ofC8txCVVDUTRFh4j5e0s1SXuY
         15A/Bg9Lky6JkNFVTyzEV0VUNwYFKvfE84sBIVtHC04ovZUr8RYxZzcJdmkYve0dPEC1
         dfUPTw72To69kp0T59aa5Y1mQ192Zej21K16o=
x-google-sender-auth: 081301e9eed5a36b
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0

T24gVHVlLCBEZWMgMiwgMjAwOCBhdCAxOjI3IEFNLCBZdSBaaGFvIDx5dS56aGFvQGludGVsLmNv
bT4gd3JvdGU6DQo+IFNSLUlPViBkcml2ZXJzIG9mIEludGVsIDgyNTc2IE5JQyBhcmUgYXZhaWxh
YmxlLiBUaGVyZSBhcmUgdHdvIHBhcnRzDQo+IG9mIHRoZSBkcml2ZXJzOiBQaHlzaWNhbCBGdW5j
dGlvbiBkcml2ZXIgYW5kIFZpcnR1YWwgRnVuY3Rpb24gZHJpdmVyLg0KPiBUaGUgUEYgZHJpdmVy
IGlzIGJhc2VkIG9uIHRoZSBJR0IgZHJpdmVyIGFuZCBpcyB1c2VkIHRvIGNvbnRyb2wgUEYgdG8N
Cj4gYWxsb2NhdGUgaGFyZHdhcmUgc3BlY2lmaWMgcmVzb3VyY2VzIGFuZCBpbnRlcmZhY2Ugd2l0
aCB0aGUgU1ItSU9WIGNvcmUuDQo+IFRoZSBWRiBkcml2ZXIgaXMgYSBuZXcgTklDIGRyaXZlciB0
aGF0IGlzIHNhbWUgYXMgdGhlIHRyYWRpdGlvbmFsIFBDSQ0KPiBkZXZpY2UgZHJpdmVyLiBJdCB3
b3JrcyBpbiBib3RoIHRoZSBob3N0IGFuZCB0aGUgZ3Vlc3QgKFhlbiBhbmQgS1ZNKQ0KPiBlbnZp
cm9ubWVudC4NCj4NCj4gVGhlc2UgdHdvIGRyaXZlcnMgYXJlIHRlc3RpbmcgdmVyc2lvbnMgYW5k
IHRoZXkgYXJlICpvbmx5KiBpbnRlbmRlZCB0bw0KPiBzaG93IGhvdyB0byB1c2UgU1ItSU9WIEFQ
SS4NCj4NCj4gSW50ZWwgODI1NzYgTklDIHNwZWNpZmljYXRpb24gY2FuIGJlIGZvdW5kIGF0Og0K
PiBodHRwOi8vZG93bmxvYWQuaW50ZWwuY29tL2Rlc2lnbi9uZXR3b3JrL2RhdGFzaHRzLzgyNTc2
X0RhdGFzaGVldF92MnAxLnBkZg0KPg0KPiBbU1ItSU9WIGRyaXZlciBleGFtcGxlIDAvMyByZXNl
bmRdIGludHJvZHVjdGlvbg0KPiBbU1ItSU9WIGRyaXZlciBleGFtcGxlIDEvMyByZXNlbmRdIFBG
IGRyaXZlcjogaGFyZHdhcmUgc3BlY2lmaWMgb3BlcmF0aW9ucw0KPiBbU1ItSU9WIGRyaXZlciBl
eGFtcGxlIDIvMyByZXNlbmRdIFBGIGRyaXZlcjogaW50ZWdyYXRlIHdpdGggU1ItSU9WIGNvcmUN
Cj4gW1NSLUlPViBkcml2ZXIgZXhhbXBsZSAzLzMgcmVzZW5kXSBWRiBkcml2ZXI6IGFuIGluZGVw
ZW5kZW50IFBDSSBOSUMgZHJpdmVyDQo+IC0tDQo+DQoNCkZpcnN0IG9mIGFsbCwgd2UgKGUxMDAw
LWRldmVsKSBkbyBzdXBwb3J0IHRoZSBTUi1JT1YgQVBJLg0KDQpXaXRoIHRoYXQgc2FpZCwgTkFL
IG9uIHRoZSBkcml2ZXIgY2hhbmdlcy4gIFdlIHdlcmUgbm90IGludm9sdmVkIGluDQp0aGVzZSBj
aGFuZ2VzIGFuZCBhcmUgY3VycmVudGx5IHdvcmtpbmcgb24gYSB2ZXJzaW9uIG9mIHRoZSBkcml2
ZXJzDQp0aGF0IHdpbGwgbWFrZSB0aGVtIGFjY2VwdGFibGUgZm9yIGtlcm5lbCBpbmNsdXNpb24u
DQoNCi0tDQpDaGVlcnMsDQpKZWZmDQo=

--_002_43F901BD926A4E43B106BF17856F07554B525811orsmsx508amrcor_--
