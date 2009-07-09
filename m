Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZGICA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZGICA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZGICAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:00:18 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:60975 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZGICAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:00:18 -0400
Message-ID: <4A554F1E.5020508@oracle.com>
Date: Wed, 08 Jul 2009 18:59:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@suse.de>,
       Peter Jones <pjones@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
References: <20090623144221.GA29593@suse.de>	 <21d7e9970907080354h6949b27va40fb830f612287@mail.gmail.com>	 <4A54A4A6.2060100@redhat.com> <4A54A538.3080407@redhat.com>	 <20090708140419.GA20418@suse.de> <4A54A938.5030807@redhat.com>	 <20090708145625.GA20690@suse.de> <4A54B5C2.9000908@redhat.com>	 <20090708154758.GB20979@suse.de>	 <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com> <b6a2187b0907081743w61102ff4u75d15c2f3cae26d@mail.gmail.com>
In-Reply-To: <b6a2187b0907081743w61102ff4u75d15c2f3cae26d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A554F10.01C0:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Thu, Jul 9, 2009 at 5:23 AM, Dave Airlie<airlied@gmail.com> wrote:
> 
>> So I don't think CONFIG_EMBEDDED is correct at least at this point.
> 
> Without CONFIG_EMBEDDED ...
>   CONFIG_NAMESPACES=y

Under General Setup, Namespaces support

> With CONFIG_EMBEDDED=y ...
>   # CONFIG_NAMESPACES is not set
>   CONFIG_VMSPLIT_3G=y
> 
> I can't find a place to change these using menuconfig when EMBEDDED is selected.

Under Processor type and features, Memory split

> I agree that CONFIG_EMBEDDED is not the right place to hide this
> becuase it changed the behavior of more than just usbfs.


~Randy
