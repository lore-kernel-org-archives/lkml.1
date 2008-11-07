Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYKGFTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYKGFTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYKGFS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:18:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:6417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYKGFS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:18:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,562,1220252400"; 
   d="scan'208";a="460308923"
Message-ID: <4913CFBC.4040203@intel.com>
Date: Fri, 07 Nov 2008 13:18:52 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
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
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081106044828.GA30417@kroah.com>
In-Reply-To: <20081106044828.GA30417@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Oct 22, 2008 at 04:38:09PM +0800, Yu Zhao wrote:
>> Greetings,
>>
>> Following patches are intended to support SR-IOV capability in the
>> Linux kernel. With these patches, people can turn a PCI device with
>> the capability into multiple ones from software perspective, which
>> will benefit KVM and achieve other purposes such as QoS, security,
>> and etc.
> 
> Is there any actual users of this API around yet?  How was it tested as
> there is no hardware to test on?  Which drivers are going to have to be
> rewritten to take advantage of this new interface?

Yes, the API is used by Intel, HP, NextIO and some other anonymous 
companies as they rise questions and send me feedback. I haven't seen 
their works but I guess some of drivers using SR-IOV API are going to be 
released soon.

My test was done with Intel 82576 Gigabit Ethernet Controller. The 
product brief is at 
http://download.intel.com/design/network/ProdBrf/320025.pdf and the spec 
is available at 
http://download.intel.com/design/network/datashts/82576_Datasheet_v2p1.pdf

Regards,
Yu
