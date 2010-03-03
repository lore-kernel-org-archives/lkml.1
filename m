Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0CCJIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:08:21 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:41076 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0CCJIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fPkgr+yLCDleac5Sk1dDyt+TRMo3X44Jcwl7Ieu8WaL4bZTKYygjjvL5kuplDHVDMs
         6+LmCPx9h5K/hoJ0zhKCahSanOgeAdPmHkMMbpKzuCG/Md8ja3Dm3tKtuYTnHtcBVdsi
         IQDh4KGD6qJzBJ7nADFu9HmhGRt0ViFahxRpI=
MIME-Version: 1.0
In-Reply-To: <2375c9f91003030058h7456b5e1odc8ca958f5af2c0d@mail.gmail.com>
References: <20100228221257.GA8858@invalid>
	 <2375c9f91002282022n29e83858jd8cadbb2e664b436@mail.gmail.com>
	 <20100301090708.GF17929@forwiss.uni-passau.de>
	 <2375c9f91003030058h7456b5e1odc8ca958f5af2c0d@mail.gmail.com>
Date: Wed, 3 Mar 2010 17:08:16 +0800
Message-ID: <2375c9f91003030108h43973d0cw713d1004dd912389@mail.gmail.com>
Subject: Re: 2.6.33 dies on modprobe
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 4:58 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Mar 1, 2010 at 5:07 PM, M G Berberich
> <berberic@fmi.uni-passau.de> wrote:
>> Hello,
>>
>> Am Montag, den 01. März schrieb Américo Wang:
>>> On Mon, Mar 1, 2010 at 6:12 AM, M G Berberich
>>> <berberic@fmi.uni-passau.de> wrote:
>>
>>> > I tried to build a 2.6.33 kernel but on boot it dies on modprobe
>>> > (kernel-Oops). This might be the result of faulty config, but I'm
>>> > totaly clueless what's the fault.
>>> >
>>> > The kernel starts up fine and mounts the root-filesystem, but then
>>> > dies on the first modprobe executed. I can boot it with init=/bin/bash
>>> > and get a working bash (until I do modprobe on any module).
>>> >
>>> > System is a Gigabyte M55S-S3 rev 2.0 (nForce 550) with an AMD Athlon64
>>> > X2 5000+ and amd64-kernel architecture. kernel-sources are from
>>> > kernel.org.
>>
>>> It seems something is wrong with forcedeth code or PCI code.
>>> Adding some Cc's.
>>
>> I don't think it's forcedeth. forcedeth just happens to be the first
>> module that get's loaded in startup. It crashes with any other module
>> too (I tried ohci_hcd).
>>
>
> Ok, below is my patch, I am not sure it could fix the BUG for you,
> but it could fix the WARNING. But perhaps they are related.
>
> Please give it a try.
>

Oops! Ignore the patch, it should not be correct, I will send a
correct version soon.
Sorry.
