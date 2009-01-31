Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbZAaFH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbZAaFH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZAaFHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:07:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZAaFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:07:50 -0500
Message-ID: <4983DBC9.5080701@kernel.org>
Date: Fri, 30 Jan 2009 21:04:09 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
 use
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org>
In-Reply-To: <49817C26.2020503@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> The failing configuration was x86-64 "make allyesconfig".
>>
>>     -hpa
>>   
> Subject: x86/paravirt: fix missing callee-save call on pud_val
> 
> Fix missed convertion to using callee-saved calls for pud_val, which
> causes a compile error when CONFIG_PARAVIRT_DEBUG is enabled.
> 

Series applied to tip:x86/paravirt; it should make its way into
tip:master and linux-next over the next day or two, unless there are
failures.

	-hpa
