Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZG1SzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZG1SzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZG1SzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:55:08 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:38784 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbZG1SzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:55:07 -0400
Message-ID: <4A6F498E.8090601@shipmail.org>
Date: Tue, 28 Jul 2009 20:55:10 +0200
From: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: ttm_mem_global
References: <1245931298.13359.8.camel@localhost.localdomain>	 <4A439D7D.9030401@shipmail.org>  <1248197676.2368.11.camel@localhost>	 <1248199231.2368.17.camel@localhost> <1248204128.2368.20.camel@localhost>	 <4A66CFDE.9090705@shipmail.org> <1248799724.2288.11.camel@localhost>
In-Reply-To: <1248799724.2288.11.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse skrev:
> On Wed, 2009-07-22 at 10:37 +0200, Thomas Hellström wrote:
>   
>> TTM has a device struct per device and an optional global struct that is 
>> common for all devices and intended to be per subsystem.
>>
>> The only subsystem currently having a global structure is the memory 
>> accounting subsystem:
>> struct ttm_mem_global
>>     
>
> Thomas i don't think the way we init ttm_mem_global today make
> it follow the 1 struct ttm_mem_global for everyone. I think it
> should be initialized and refcounted by device struct.
>
> So on first device creation a ttm_mem_global is created and
> then anytime a new device is created the refcount of ttm_mem_global
> is increased. 
Jerome,
This is exactly what the current code intends to do.

Are you seeing something different?

/Thomas


