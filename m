Return-Path: <linux-kernel-owner+w=401wt.eu-S1161258AbXDKVvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbXDKVvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161264AbXDKVvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:51:42 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:62953 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161258AbXDKVvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:51:41 -0400
Date: Wed, 11 Apr 2007 23:51:33 +0200 (CEST)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@p4.localdomain
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: Fix sudden warps in mousedev
In-Reply-To: <200703262114.45287.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0704112349490.4764@p4.localdomain>
References: <20070324001610.724a820a.zaitcev@redhat.com>
 <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com>
 <20070326144206.93805eeb.zaitcev@redhat.com> <200703262114.45287.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Dmitry Torokhov wrote:

> On Monday 26 March 2007 17:42, Pete Zaitcev wrote:
>>
>> I don't think that you need to concern yourself with this too much
>> at present. If X11 people (e.g. Kristian) present evidence that kernel
>> fails to deliver an event, then we'll look at it. However it might
>> help if evtest continued to work when X11 reads from /dev/input/eventN.
>> It was an unpleasant surprise that it doesn't.
>
> The driver grabs tochpad with EVIOCGRAB ioctl to prevent input events
> from bveing delivered to X through /dev/input/mice which is still in
> whidespread use. That's why evtest does not work. We could as Peter
> (CCed) to implement an option to turn off grabbing so users who don't
> use mousedev multiplexor can use evtest and other commands.

That sounds like a useful option. Implemented in my git tree:

git clone http://web.telia.com/~u89404340/touchpad/synaptics/.git

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
