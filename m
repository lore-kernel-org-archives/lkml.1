Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbYKGG24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbYKGG24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYKGG2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:28:36 -0500
Received: from kroah.org ([198.145.64.141]:48918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755100AbYKGG2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:28:35 -0500
Date: Thu, 6 Nov 2008 22:07:07 -0800
From: Greg KH <greg@kroah.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081107060707.GA3860@kroah.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081106044828.GA30417@kroah.com> <4913CFBC.4040203@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4913CFBC.4040203@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:18:52PM +0800, Zhao, Yu wrote:
> Greg KH wrote:
>> On Wed, Oct 22, 2008 at 04:38:09PM +0800, Yu Zhao wrote:
>>> Greetings,
>>>
>>> Following patches are intended to support SR-IOV capability in the
>>> Linux kernel. With these patches, people can turn a PCI device with
>>> the capability into multiple ones from software perspective, which
>>> will benefit KVM and achieve other purposes such as QoS, security,
>>> and etc.
>> Is there any actual users of this API around yet?  How was it tested as
>> there is no hardware to test on?  Which drivers are going to have to be
>> rewritten to take advantage of this new interface?
>
> Yes, the API is used by Intel, HP, NextIO and some other anonymous 
> companies as they rise questions and send me feedback. I haven't seen their 
> works but I guess some of drivers using SR-IOV API are going to be released 
> soon.

Well, we can't merge infrastructure without seeing the users of that
infrastructure, right?

> My test was done with Intel 82576 Gigabit Ethernet Controller. The product 
> brief is at http://download.intel.com/design/network/ProdBrf/320025.pdf and 
> the spec is available at 
> http://download.intel.com/design/network/datashts/82576_Datasheet_v2p1.pdf

Cool, do you have that driver we can see?

How does it interact and handle the kvm and xen issues that have been
posted?

thanks,

greg k-h
