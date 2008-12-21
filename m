Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYLUWSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYLUWSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYLUWRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:17:52 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:35193 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYLUWRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:17:51 -0500
Message-ID: <494EC082.2010207@gmail.com>
Date: Mon, 22 Dec 2008 00:17:38 +0200
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com> <20081220221253.e09b1b1f.akpm@linux-foundation.org> <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com> <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com> <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz> <alpine.DEB.2.00.0812211441300.7101@parag-desktop> <alpine.LNX.1.10.0812212247090.26265@jikos.suse.cz> <20081221140200.40c1fec1.akpm@linux-foundation.org> <alpine.LNX.1.10.0812212302400.26265@jikos.suse.cz> <alpine.DEB.2.00.0812211708450.7101@parag-desktop>
In-Reply-To: <alpine.DEB.2.00.0812211708450.7101@parag-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> 
> On Sun, 21 Dec 2008, Jiri Kosina wrote:
> 
>> On Sun, 21 Dec 2008, Andrew Morton wrote:
>>
>>>> So do I get it right that the only reason of the problem you were 
>>>> seeing was that in the 2.6.27 kernel you have compiled usbhid module, 
>>>> which was then used for driving your mouse,but in 2.6.28-rcX you 
>>>> compiled and used 'usbmouse' instead, and therefore this is not a 
>>>> regression?
>>> Shouldn't usbmouse support two-dimensional mice as well?
>> Yup, but that's a separate issue on my TODO. I first want to know whether 
>> this is a regression or not.
>>
> 
> I have always compiled usbmouse as a module - the problem or regression 
> here was that it was loaded instead of usbhid when both were compiled as 
> modules - but I don't think this is a kernel regression, here is why -
> 
> The problem happened with Fedora 10 - when I booted into Ubuntu 8.10 with 
> the same kernel compiled with same config, usbhid was correctly loaded and 
> mouse worked. So I would forget this as a Fedora specific issue.

It may well be that Ubuntu has usbmouse blacklisted or employs udev
rules that force usbhid to be loaded before usbmouse.

On Mandriva it was handled in a similar way, before usbmouse was
disabled from the kernel (no reason to have it in a "normal" kernel).

> Thanks for the pointers.

-- 
Anssi Hannula
