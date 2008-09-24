Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbYIXJmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbYIXJmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYIXJm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:42:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36218 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYIXJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=J0skuIM/y5Mopb3LbLGC+izVs/hsFoAB1YA7TGepN1YXuovkTnM9Z0Hw+66u4QRfq9
         E7lCHJVEExdhZGUqfx6M+360KTJccRn927SYqn+lwdUzuMPyETDGvjyNGfKebOam3kgF
         qvwGQC+4K/JzpjnZ6uxPBolHfP6k/kZd5XPB4=
Message-ID: <48DA0B7D.3060801@gmail.com>
Date: Wed, 24 Sep 2008 11:42:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Matthew Ranostay <mranostay@embeddedalley.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: hda_intel (sigmatel) defunct in mmotm 2008-09-13-03-09
References: <48CE6A90.1070309@gmail.com> <48CFC601.9050608@embeddedalley.com> <48D0C69D.4090105@gmail.com> <48D10F8F.5090703@embeddedalley.com>
In-Reply-To: <48D10F8F.5090703@embeddedalley.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2008 04:09 PM, Matthew Ranostay wrote:
> Jiri Slaby wrote:
>> On 09/16/2008 04:43 PM, Matthew Ranostay wrote:
>>> Bug fix patch at:
>>>
>>> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-September/010767.html
>> It works, thanks.
> 
>> Another problem is when I switch IEC958 in alsamixer, I get:
> 
> 
> Ok, the problem was that codec->slave_dig_outs getting a dereference when NULL.
> This has been already fixed in Takashi's sound-2.6.git tree, with the commit id
> 06efc354f735d5dbbdf4653fc6a8acd489ac5a18.

ACKing this. Thanks.
