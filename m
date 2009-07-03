Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZGCHX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZGCHX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZGCHXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:23:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45470 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZGCHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OtmtLmbok57m0Wo+svaXsJ2Qmi8cr5YNec5o5p0kGLBPXajXBC9WU9O4hCWzbaZwIt
         2KPZG9CcQL4XpJ31iyQfNYAnUYqDrWoHykm5sXIWVAlQCqs2WEqOsw7vf2Ge8qrMY/zf
         Nhbn71cY6Hqk8kR41Yih9CjyStEtxhHDnCphk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <1246374095.8014.28.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906301114450.3879@gentwo.org>
	 <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
	 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0906301722280.17682@gentwo.org>
	 <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com>
	 <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
	 <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com>
Date: Fri, 3 Jul 2009 10:23:48 +0300
X-Google-Sender-Auth: 34cc70cb9e97e38b
Message-ID: <84144f020907030023v2d09632bt13b6c25f96c0b803@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 1 Jul 2009, Pekka Enberg wrote:
>> Lets go with the slab_out_of_memory() patch you outlined in a previous
>> post and implement the slub_debug=p thing Christoph suggested. I think
>> it's the best compromise at this point. When you guys finally see the
>> light, we can always change it to a reasonable default. ;)
>>
>> So can you send a patch, please?

On Thu, Jul 2, 2009 at 8:18 PM, David Rientjes<rientjes@google.com> wrote:
> Sure, let me know if you think this is -rc material; otherwise, the bug
> will have to be deferred until 2.6.32 with the temporary workaround of
> disabling CONFIG_SLUB_DEBUG_ON.

We're at -rc2 so yes, I do think we should fix 2.6.31.
