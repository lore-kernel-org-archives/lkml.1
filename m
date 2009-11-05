Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbZKEAFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbZKEAFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZKEAFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:05:38 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60337 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZKEAFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XT3fdV0kCdVAij375qCci23q/J2xQBAY7jgu/vMjhlTE/DQwXTxYNw1670pGz5stXC
         MbyQHmMXkW8BsODNjnNMDLHjO/5h9GDQwD89w8ChK73cPOSGYYpUK9Z9vp0sY02Go3ur
         SoAZSTDprv8fQzjeTcMGNz2ptkwCv6cq3qVjI=
Message-ID: <4AF216D3.4040903@gmail.com>
Date: Wed, 04 Nov 2009 18:05:39 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Options: To use MSI-X or not?
References: <alpine.DEB.2.00.0911041151410.17867@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911041151410.17867@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 10:53 AM, Justin Piszcz wrote:
> Hello,
>
> I was curious whether its best to use MSI-X when the driver supports it
> or not?
>
> Example, 3ware cards/Intel Audio Drivers you can use MSI-X instead of
> having several devices use/share an interrupt.
>
> What are the pros/cons to using MSI-X vs. having devices share an IRQ?

Normally using MSI/MSI-X is always better (or at least no worse), 
assuming it works properly on the system and on the device.. Hopefully 
by this point we've fixed most or all the system-related problems or 
forced MSI off on platforms where it can't work properly.
