Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZKSPHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZKSPHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZKSPHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:07:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55017 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZKSPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:07:41 -0500
Message-ID: <4B055F24.8030307@zytor.com>
Date: Thu, 19 Nov 2009 07:07:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
References: <20091116190739.GJ4764@const.famille.thibault.fr> <20091116195313.GB4462@x200> <20091116222738.GQ4764@const.famille.thibault.fr> <20091116225429.GB4764@const.famille.thibault.fr> <20091116230523.GC24961@x200> <20091116231520.GD4764@const.famille.thibault.fr> <20091117115503.GB1657@x200> <20091117132358.GJ12736@const.bordeaux.inria.fr> <20091119131854.GA1628@x200.localdomain> <20091119132828.GA31025@const.bordeaux.inria.fr> <20091119133737.GE31025@const.bordeaux.inria.fr>
In-Reply-To: <20091119133737.GE31025@const.bordeaux.inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 05:37 AM, Samuel Thibault wrote:
> 
> So we agree, and so the right solution is to either completely rework
> the interface (ugh), or just add LED routing (which can be very useful,
> actually, I for instance don't care at all about the num lock state, but
> I _do_ care about the lock that lets me shift between different keyboard
> layouts).
> 

Adding LED routing and using keyboard levels is so clearly The Right Thing.

We already allow the LEDs to be programmed; we should probably just
have, for each LED, the ability to program it off/on/flashing/connected
to modifier #X.

The current KDSETLED/KDGETLED interface is of course too limited for
this -- we need an interface with at least a byte per LED.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

