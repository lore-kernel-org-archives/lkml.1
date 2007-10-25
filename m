Return-Path: <linux-kernel-owner+w=401wt.eu-S1761811AbXJYHfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761811AbXJYHfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 03:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXJYHfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 03:35:25 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:55936 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbXJYHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 03:35:25 -0400
Message-ID: <29046.145.64.134.222.1193297714.squirrel@www.hardeman.nu>
In-Reply-To: <47203073.7090809@garzik.org>
References: <20071024155845.5129d6a4.kristen.c.accardi@intel.com>
    <47203073.7090809@garzik.org>
Date: Thu, 25 Oct 2007 09:35:14 +0200 (CEST)
Subject: Re: [PATCH] ata: ahci: Enable enclosure management via LED (resend)
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "Kristen Carlson Accardi" <kristen.c.accardi@intel.com>,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, October 25, 2007 07:58, Jeff Garzik wrote:
> Kristen Carlson Accardi wrote:
>> Enable enclosure management via LED
>>
>> As described in the AHCI spec, some AHCI controllers may support
>> Enclosure management via a variety of protocols.  This patch
>> adds support for the LED message type that is specified in
>> AHCI 1.1 and higher.
>
> Comments:
...
> 8) when is this actually used?  do you have a sample user in userspace?
>   does a userspace daemon watch disk activity and manage LEDs somehow?
> I'm a bit cloudy on the usage need of this.

I think the idea is that if mdadm (for example) kicks out a faulty disk
from an array, it could also activate a LED (usually a different LED than
the "disk activity" LED) on the corresponding enclosure so that the admin
knows when standing in front of the storage server which disk to pull out
and replace.

-- 
David Härdeman

