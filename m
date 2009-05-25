Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZEYRXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZEYRXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZEYRXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:23:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:49909 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZEYRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CIafNJ9D0kt26qZW2mnzSVWqQN9qnicj98om4igZTF1TGLGhecOfuGRw3ep70OvJOF
         vglvM3w9jXvDGlyloHO7vAp90x1Gf2LOn0Y8SU3Yy2CRO0TkydEx3QV2g7cST3tH2Vk5
         uzuEYUrmG3rMM/YddsG5B9vGwESSJuVAb5bKM=
Message-ID: <4A1AD3D1.2010806@gmail.com>
Date: Mon, 25 May 2009 19:22:25 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: 2 bugs related to suspend to disk
References: <4A199A7A.3010705@gmail.com> <20090524205450.GA1693@elf.ucw.cz> <4A19C2A3.6030501@gmail.com> <200905250004.11927.rjw@sisk.pl>
In-Reply-To: <200905250004.11927.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday 24 May 2009, Marcin Slusarz wrote:
>> Pavel Machek wrote:
>>> Hi!
>>>
>>>
>>>> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
>>>>
>>> I'm afraid we need more details here. Is "resume" binary being ran?
>> Excellent question ;) - I didn't know it has to. I'll try to setup
>> initramfs tomorrow.
>>
>> Thanks and sorry for the noise!
> 
> However, the issue reported as 1) is not really a noise IMO. :-)
> 
> Can you please attach a full dmesg output containing these messages?

I've uploaded .config, dmesg (BUG was not saved) and 2 pictures of
screen just before power loss to http://www.kadu.net/~joi/kernel/2009.05.25/
(Please ignore first suspend failure (3681.078646 - 3685.514358) - I forgot
to restore swap)

Marcin


