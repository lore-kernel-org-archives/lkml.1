Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZBSQxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZBSQxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZBSQxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:53:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:43469 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZBSQxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:53:31 -0500
Cc: "Ira Snyder" <iws@ovro.caltech.edu>, "Arnd Bergmann" <arnd@arndb.de>,
       "Jan-Bernd Themann" <THEMANN@de.ibm.com>, <netdev@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Message-Id: <C04B22C6-BCE8-4D99-A160-22F8846C8209@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zang Roy-R61911 <tie-fei.zang@freescale.com>
In-Reply-To: <7DF0AF56456B8F4081E3C44CCCE311DE1519A3@zch01exm23.fsl.freescale.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [RFC v1] virtio: add virtio-over-PCI driver
Date: Thu, 19 Feb 2009 10:51:43 -0600
References: <20090217222425.GA18801@ovro.caltech.edu> <D999D051-E5A2-4915-893D-E3384EC312A4@kernel.crashing.org> <7DF0AF56456B8F4081E3C44CCCE311DE1519A3@zch01exm23.fsl.freescale.net>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19, 2009, at 12:13 AM, Zang Roy-R61911 wrote:

>
>
>> -----Original Message-----
>> From:
>> linuxppc-dev-bounces+tie-fei.zang=freescale.com@ozlabs.org
>> [mailto:linuxppc-dev-bounces+tie-fei.zang=freescale.com@ozlabs
>> .org] On Behalf Of Kumar Gala
>> Sent: Thursday, February 19, 2009 0:47 AM
>> To: Ira Snyder
>> Cc: Arnd Bergmann; Jan-Bernd Themann; netdev@vger.kernel.org;
>> Rusty Russell; linux-kernel@vger.kernel.org; linuxppc-dev@ozlabs.org
>> Subject: Re: [RFC v1] virtio: add virtio-over-PCI driver
>>
>>
>> On Feb 17, 2009, at 4:24 PM, Ira Snyder wrote:
>>
>>>
>>> Documentation/virtio-over-PCI.txt     |   61 ++
>>> arch/powerpc/boot/dts/mpc834x_mds.dts |    7 +
>>
>> we'll have to review the .dts and expect a documentation update for
>> the node.  But that's pretty minor at this point.
>>
>>> drivers/virtio/Kconfig                |   22 +
>>> drivers/virtio/Makefile               |    2 +
>>> drivers/virtio/vop.h                  |  119 ++
>>> drivers/virtio/vop_fsl.c              | 1911
>> ++++++++++++++++++++++++
>>> +++++++++
>>
>> make this vop_fsl_mpc83xx.c or something along those lines.
> why?

so we can deal with 85xx as well.  We just need to isolate the 83xx  
specific bits (message usage)

- k
