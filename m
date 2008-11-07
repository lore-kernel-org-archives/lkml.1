Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYKGGG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYKGGG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYKGGGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:06:19 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:17303 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYKGGGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E1FaTweDuH0XM+Li323wXZCjfgXsODXitYsD75NwBhWFM1p75/Fpgfqic9mMsgdIWe
         vPvkF1vOkOvGLwuXzsXEtR9c7mma57O7mTi7VFt4gjAWjueWkFOjIxaYA2BjsL2c7/DD
         JftRu2pVH0ZOi4OATQIhbf9XCDNzh0y+v24cM=
Message-ID: <43e72e890811062206w1c2e669fnc16dc5fcf9e2d505@mail.gmail.com>
Date: Thu, 6 Nov 2008 22:06:17 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>, "Zhu Yi" <yi.zhu@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226037518.3023.60.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225944979.3792.3.camel@calx>
	 <5109BB99-53F1-499A-9D0B-FAB77591FBD5@linux.intel.com>
	 <1226037518.3023.60.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 9:58 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Fri, 2008-11-07 at 05:40 +0100, Marcel Holtmann wrote:
>> Hi Matt,
>>
>> > [ 5470.869820] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204
>> > iwl_rx_handle+0x11a/0x21b [iwlagn]()
>> > [ 5470.869824] wrong command queue 31, command id 0x0
>>
>> I am seeing this a lot with my X61 running a 64-bit kernel/OS and my D-
>> Link DIR-615 access point. With some other access points I am seeing
>> it never or a lot less.
>
>> What kind of laptop and access point are you using? Is you access
>> point 802.11n capable? Do you run the i386 or x86_64 version of your
>> distro?
>
> Laptop is a Fujitsu 8010p. I've tried this with kernel only once with a
> G-capable Airport (with various other unknown access points in range),
> but it failed to find any networks. 64-bit kernel and Debian unstable.
>
> 2.6.27 mostly works fine here, though occasionally I need to load/unload
> iwlagn after s2ram.

FWIW I get this on 32 bit kernel, wireless-testing, 11G AP, and it
happens a lot. But its a very noisy environment.

  Luis
