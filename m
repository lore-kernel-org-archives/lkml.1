Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZABPuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZABPuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbZABPti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:49:38 -0500
Received: from mail.lang.hm ([64.81.33.126]:56771 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbZABPtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:49:36 -0500
Date: Fri, 2 Jan 2009 08:51:28 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
In-Reply-To: <11444.1230910752@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.1.10.0901020849180.20509@asgard.lang.hm>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu>            <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
 <11444.1230910752@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 02 Jan 2009 20:40:16 +0530, Jaswinder Singh Rajput said:
>
>> If I know what is my CPU there is no point for supporting all related
>> CPUs in my kernel.
>
> EMBEDDED is for a large assortment of things, all of which are of the form:
>
> General users won't want to change Y, but if I know I don't need Y, there is
> no point in supporting Y in the kernel.
>
> Y might be "this kernel doesn't need sysctl"
> Y might be "support for hot-plug"
> Y might be "printk"
> Y might be "support generic CPUs"
>
> See the pattern?
>
> Yes, we probably could have come up with a better name than EMBEDDED for
> that list of optionals.
>
> CONFIG_TRAINED_TECHNICIANS_ONLY_NO_USER_SERVICABLE_PARTS_INSIDE maybe?

having things outside of the embedded menu depend on embedded makes it 
hard for people to figure out what they need to do to disable specific 
things.

namespaces are also required if ! embedded, but namespaces are not (yet at 
least) something that is commonly used.

if you follow the logic you are providing to it's logical conclusion you 
may as well put all kernel config options under "I really know what I'm 
doing" top level lockout

David Lang
