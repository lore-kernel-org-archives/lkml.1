Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0BOSeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:34:20 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:39217 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0BOSeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H6Qhc3/5RcdWhLlfjhIIJ7Gl6Roj/pnsCdbdem87jsGxsBBbrsZUsHaSu5lBT9AJik
         avWmqKrNFtMCHiAdKiP/9pH4iunTZmksbAvSBWEib5K0btKUmG9+XfuL+AvDzx6z3Jso
         SNtqFp5cUmwJ5RCeHGckFLbtUNNjsc99bOrYA=
MIME-Version: 1.0
In-Reply-To: <4B772F74.1030509@garzik.org>
References: <4B5FC213.1060601@gmail.com> <4B772BE2.30108@garzik.org>
	 <51f3faa71002131453m4dd2b82cgd8b874866146da60@mail.gmail.com>
	 <4B772F74.1030509@garzik.org>
Date: Mon, 15 Feb 2010 12:34:18 -0600
Message-ID: <51f3faa71002151034k225d204fr5ce0af821e39c639@mail.gmail.com>
Subject: Re: [PATCH] ahci: disable FPDMA auto-activate optimization on NVIDIA 
	AHCI
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Mike Cui <cuicui@gmail.com>,
       Peer Chen <pchen@nvidia.com>, Allen Martin <AMartin@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 5:02 PM, Jeff Garzik <jeff@garzik.org> wrote:
>>>> Mike, can you test this out and make sure this resolves the problem for
>>>> you?
>>>
>>> Sigh...   we never did hear back from Mike or NVIDIA on this one, did we?
>>>  I've been watching for a response, and haven't seen one to date.
>>
>> No, I haven't seen a response. It's pretty apparent it should fix the
>> problem based on earlier testing, but it would be nice to find out for
>> sure which chipsets this affects.
>
> Yep, that's my main concern...  being overly aggressive and zapping it on
> all NVIDIA chipsets, even future ones.

I'm thinking if we don't hear any more specifics on the problem from
NVIDIA or someone otherwise knowledgeable Real Soon Now we should
likely just merge this patch. MCP79 is a fairly new chipset and it's
likely a good assumption that the older NVIDIA AHCI chipsets would
have the same issue. It's possible that some of the newer chipsets do
or will fix the problem, but we can address that at a later date - the
auto-activate optimization is pretty minor and not worth breaking
things if there's doubt of it working on these controllers..
