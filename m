Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYEEOUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYEEOUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbYEEOTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:19:50 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:62514 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758894AbYEEOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:19:49 -0400
Message-ID: <481F17C3.90509@seznam.cz>
Date: Mon, 05 May 2008 16:20:51 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 13/56] microblaze_v2: PVR support, cpuinfo support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>	 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>	 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>	 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>	 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>	 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>	 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>	 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>	 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>	 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu> <1209953663.5798.61.camel@localhost>
In-Reply-To: <1209953663.5798.61.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXED.


>> +int cpu_has_pvr(void)
>> +{
>> +	unsigned flags;
>> +	unsigned pvr0;
>> +	int ret = 0;
>> +
>> +	local_irq_save(flags);
>> +
> 
> ...
> 
>> +out:
>> +	local_irq_restore(flags);
>> +	return ret;
>> +}
> 
> The actual IRQ clear/restore is not required - can you just use
> local_save_flags() or similar to read the MSR?

