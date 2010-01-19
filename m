Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938Ab0ASJev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0ASJev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585Ab0ASJes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:34:48 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:53559 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0ASJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:34:47 -0500
Message-ID: <4B557CB6.2060204@pardus.org.tr>
Date: Tue, 19 Jan 2010 11:34:46 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B31C8EE.3030003@kernel.org> <d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com> 	<4B331771.3090309@kernel.org> <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com> <4B532CB7.4060005@pardus.org.tr> <4B5575C8.4030205@kernel.org>
In-Reply-To: <4B5575C8.4030205@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On 01/18/2010 12:28 AM, Ozan Çağlayan wrote:
>> [    9.769407] ata1: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000c700) ACPI=0x701f (60:600:0x13)                                                  
>> [    9.775326] ata1.00: configured for UDMA/33                                  
>> [    9.775408] ata1.00: TEST_UNIT_READY failed (err_mask=0x2)                 
> 
> Hmmm... err_mask=0x2 is HSM error.  Strange.  Does the attached patch
> make any difference?

Hi,

He reported back that after a few reboots its now working correctly. Actually the behaviour is a little bit
random as he succesfully installed the OS from a CD without losing its DVD drive.

I'll keep a patched kernel and send to him for testing if the bug reappears.

Thanks,
