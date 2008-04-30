Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYD3CRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYD3CRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 22:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYD3CQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 22:16:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:42909 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbYD3CQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 22:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dDlXHAHzV03yeKF0XqJLmN9wCO91rvmp72oTnq0Lwmco9exxsdLcwjFQKuQHonIzkcwH5f8NNxxyO4lx4JliuvDSqLydKyM9Q8tZd7HItgZ/twqU/QnbGpfA+sc1BjFSs9H+MIFgBrMMBKJ5FreSjbBeXzh+9h3VlX3kmR/f+5Y=
Message-ID: <4817D687.8080201@googlemail.com>
Date: Wed, 30 Apr 2008 04:16:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Dave Airlie <airlied@linux.ie>, Gabriel C <crazy@frugalware.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
References: <4815EEB4.2060509@frugalware.org> <alpine.DEB.0.82.0804282016440.5277@skynet.skynet.ie> <481678C6.7050400@googlemail.com> <200804291104.47687.jbarnes@virtuousgeek.org> <4817A9D3.1030309@googlemail.com>
In-Reply-To: <4817A9D3.1030309@googlemail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Jesse Barnes wrote:
>> On Monday, April 28, 2008 6:24 pm Gabriel C wrote:
>>> Dave Airlie wrote:
>>>> On Mon, 28 Apr 2008, Gabriel C wrote:
>>>>> Hello ,
>>>>>
>>>>> are there any plans to add G33 / Q33 / Q35 chipsets support for the
>>>>> intelfb driver ? Is this driver still maintained ?
>>>>>
>>>>> ( I'm not really sure who maintains this driver so I've add peoples to
>>>>> CC I saw worked on it , I've also added Wang Zhenyu to CC while he added
>>>>> this support for AGP )
>>>> Intel fb is unmaintained (well I've done trivial fixes in the past), and
>>>> I'd rather not add new chipset support to it.
>>>>
>>>> We are working (RH and Intel) on a new kernel modesetting layer which
>>>> will allow fbs integrated with proper memory management and support all
>>>> intel hw,
>>> Good news :)
>>>
>>> Are there any patch(es) / git tree one could try out ?
>> See the modesetting-101 branch of git://git.freedesktop.org/git/mesa/drm.  
>> It's a bit rough in spots but the i915 driver should be pretty close to 
>> feature parity with the Intel X driver at this point.
> 
> Thx , I will try out the tree.
> 

modesetting-101 does not compile on current git , NOPAGE_SIGBUS , nopage and friends gone.


Gabriel 
