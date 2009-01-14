Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZANFSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZANFSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZANFSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:18:25 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:20267 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZANFSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:18:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Pkh2UzJ9pMwbSf46a8Wbt/C8UuGCVkNiunsEKpRM7bo6c3p2hFOEozrrEM3X1pcdlN
         1li4u9kfrKrAITG15jdIxkAnz5r7KbeKZE/gqojQpvlqduxjf4eGiaBt/L10gmBf/6eJ
         DHAmiW+V3E2nGPNiN6XZpge6qnmgEu9q3L/hA=
Message-ID: <496D759A.7010401@gmail.com>
Date: Tue, 13 Jan 2009 21:18:18 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: netlabel: UNLABELED ath9k not denying unlabeled traffic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using netlabelctl on a dell laptop
I'm able to define the addresses that I want:

netlabelctl unlbl add interface:wlan0 address:<radiostation> 
label:system_u:object_r:netlabel_peer_t:s0
netlabelctl unlbl add interface:wlan0 address:<myaddress> 
label:system_u:object_r:netlabel_peer_t:s0
netlabelctl  -p unlbl accept off

{the above was from http://paulmoore.livejournal.com/1758.html };
(I'm able to listen to the radio station allowed, then if I choose 
another station; if I haven't defined an address like the above, mplayer 
just sits there.denying the unlabeled packet. that is until I allow the 
address);

The problem I have is when I do the same on my macbook pro ati chipset.
with the ath9k module, I'm able to listen to any station, search the web 
etc..
it seems netlabelctl  -p unlbl accept off makes no difference if it's on 
or off.
 
Is this built into ath9k yet, or is there something I'm missing?

regards;

Justin P. Mattock

