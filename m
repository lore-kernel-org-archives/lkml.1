Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZINLDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZINLDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZINLDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:03:16 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64386 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ORDApbq5jJaX/+YBycNJRoSVhujxP5t84JlVIzZf3jyQHemJnqaAN47XLR3lhcuKh/
         Q6gHFwvdyshEyNBE6yEXFq/E1Bfflgvm2TqOOeU+vUgn5/eFsKhzcqJKHHUdC2SHvqVO
         HtvJ6wYoEOnVavtpWHfV7x1xvgdP38fWtsVug=
Message-ID: <4AAE22CF.1020609@tuffmail.co.uk>
Date: Mon, 14 Sep 2009 12:02:39 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Corentin Chary <corentincj@iksaif.net>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] dell-laptop: fix rfkill memory leak on unload
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net> <1252925033-29696-2-git-send-email-corentincj@iksaif.net> <1252925033-29696-3-git-send-email-corentincj@iksaif.net> <1252925033-29696-4-git-send-email-corentincj@iksaif.net> <20090914104616.GA6170@srcf.ucam.org>
In-Reply-To: <20090914104616.GA6170@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Sep 14, 2009 at 12:43:53PM +0200, Corentin Chary wrote:
>   
>> rfkill_unregister() should always be followed by rfkill_destroy()
>>
>> Cc: Matthew Garrett <mjg@redhat.com>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>>     
>
> Acked-by: Matthew Garrett <mjg@redhat.com>
>
>   

I can endorse this as I already submitted something similar :-). 
<http://patchwork.kernel.org/patch/42699/> (with a disclaimer that it
was not tested on dell hardware).
