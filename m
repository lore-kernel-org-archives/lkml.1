Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbZANO50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbZANO50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZANO5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:57:15 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:18113 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZANO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:57:14 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Wed, 14 Jan 2009 09:57:09 -0500
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <496D759A.7010401@gmail.com>
In-Reply-To: <496D759A.7010401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901140957.09722.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 12:18:18 am Justin P. Mattock wrote:
> When using netlabelctl on a dell laptop
> I'm able to define the addresses that I want:
>
> netlabelctl unlbl add interface:wlan0 address:<radiostation>
> label:system_u:object_r:netlabel_peer_t:s0
> netlabelctl unlbl add interface:wlan0 address:<myaddress>
> label:system_u:object_r:netlabel_peer_t:s0
> netlabelctl  -p unlbl accept off
>
> {the above was from http://paulmoore.livejournal.com/1758.html };

Hey, somebody actually reads that stuff!  I guess I'll need to be 
careful what I write from now on :)

Hi Justin, on a more serious note, if you are having problems with 
labeled networking it's probably a good idea to CC the SELinux, LSM 
and/or netdev lists depending on the issue as I often miss mail if it 
is only posted to LKML.  When in doubt you can just CC me personally 
(paul.moore@hp.com) and I'll add whatever list seems appropriate.

> (I'm able to listen to the radio station allowed, then if I choose
> another station; if I haven't defined an address like the above,
> mplayer just sits there.denying the unlabeled packet. that is until I
> allow the address);

Good, that is how it should work give the configuration shown above.

> The problem I have is when I do the same on my macbook pro ati
> chipset. with the ath9k module, I'm able to listen to any station,
> search the web etc..
> it seems netlabelctl  -p unlbl accept off makes no difference if it's
> on or off.
>
> Is this built into ath9k yet, or is there something I'm missing?

That is just plain odd, there isn't really anything that is driver 
specific.  Can you share any more details like kernel version, 
netlabel_tools verion, distro, etc?  I don't have any ath9k hardware 
lying around to test so I would appreciate whatever additional 
information you can provide.

-- 
paul moore
linux @ hp
