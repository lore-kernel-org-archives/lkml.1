Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0BBXKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:10:19 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:65500 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab0BBXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:10:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Vi0iVfLro01Vz1OBbCbPD+hFYCIB2EqU/S8ldZgT/LOU3gyExc8JlguNMBO7SWIIBE
         7BXl0qYSWGLywsdn1D1O/eGfO4DeeK/T7ZXNNxuxHm1MMiJYSTDfrZv2jDNgeHJ46Q3i
         FWk3PcFfcNSQEJvLuzTZ/X/pcdxaftZznxrWA=
Message-ID: <4B68B0CF.1040907@garzik.org>
Date: Tue, 02 Feb 2010 18:10:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
References: <20100201114824.29682015@lxorguk.ukuu.org.uk>	<20100201.044813.27473014.davem@davemloft.net>	<20100201125845.3f468363@lxorguk.ukuu.org.uk> <20100201.051432.226757615.davem@davemloft.net>
In-Reply-To: <20100201.051432.226757615.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 06:17 AM, David Miller wrote:
> And then once that hard work is done, we kind of just toss it
> for one side of the equation?
[...]

On 02/01/2010 08:14 AM, David Miller wrote:
> I have not advocated the ifdef implementation.
>
> I have advocated one where the data structures are actually
> the same, and there are no ifdefs.

It all sounds like the exact opposite of what you said seven months ago:

	I'm going to treat IDE as pure legacy, rather than as
	competition with the PATA drivers which is what people whould
	be moving over to.

	And more importantly I refuse to apply any driver patch that
	isn't actually tested on said hardware.

It's either legacy, or it isn't.  It's either bug-fixes-only, or it 
isn't.  Touching, quite literally, _100%_ of the IDE drivers does not 
meet the criteria of "pure legacy" nor likely "actually tested on said 
hardware."

But hey...  if you want to accept patches slowly turning IDE into 
libata, that's your call :)  It just seems quite contrary to what has 
been sold to the remaining IDE users.

	Jeff



