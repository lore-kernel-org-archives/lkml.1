Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYLCDMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYLCDMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYLCDMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:12:21 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:52146 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYLCDMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IxnRuQwy6BoNr8tCH3S7MAx3RyGAmPYkE97itIoEW+nirbaY25kdnNpykrDsm1I79v
         iIO86qhiEft06xP1ky1dkr+IdbB72w8mz/L/6c7NOAE56CGU+jYh372C8bvchH6rpCKM
         OzwbAIceX2z2eWBn3bL7Tuq+5TaGjB8pCgnY4=
Message-ID: <9929d2390812021912ua5ddeafo3ae4a5759ffc4c4e@mail.gmail.com>
Date: Tue, 2 Dec 2008 19:12:18 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Yu Zhao" <yu.zhao@intel.com>
Subject: Re: [SR-IOV driver example 0/3 resend] introduction
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       netdev@vger.kernel.org, jun.nakajima@intel.com,
       gregory.v.rose@intel.com
In-Reply-To: <20081202092741.GA1859@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
	 <20081202092741.GA1859@yzhao12-linux.sh.intel.com>
X-Google-Sender-Auth: 081301e9eed5a36b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 1:27 AM, Yu Zhao <yu.zhao@intel.com> wrote:
> SR-IOV drivers of Intel 82576 NIC are available. There are two parts
> of the drivers: Physical Function driver and Virtual Function driver.
> The PF driver is based on the IGB driver and is used to control PF to
> allocate hardware specific resources and interface with the SR-IOV core.
> The VF driver is a new NIC driver that is same as the traditional PCI
> device driver. It works in both the host and the guest (Xen and KVM)
> environment.
>
> These two drivers are testing versions and they are *only* intended to
> show how to use SR-IOV API.
>
> Intel 82576 NIC specification can be found at:
> http://download.intel.com/design/network/datashts/82576_Datasheet_v2p1.pdf
>
> [SR-IOV driver example 0/3 resend] introduction
> [SR-IOV driver example 1/3 resend] PF driver: hardware specific operations
> [SR-IOV driver example 2/3 resend] PF driver: integrate with SR-IOV core
> [SR-IOV driver example 3/3 resend] VF driver: an independent PCI NIC driver
> --
>

First of all, we (e1000-devel) do support the SR-IOV API.

With that said, NAK on the driver changes.  We were not involved in
these changes and are currently working on a version of the drivers
that will make them acceptable for kernel inclusion.

-- 
Cheers,
Jeff
