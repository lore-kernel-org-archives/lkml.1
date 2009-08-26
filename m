Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZHZGWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZHZGWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZHZGWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:22:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45090 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZHZGWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EI4U7y/7VC2Z52TzstI7CObpnaiQ0gb3YuOx+VxUbW/1ILbpqW1LHZHNiw87ROvZWI
         7C/vizf9Xc9C61I4P6cLHQkXURUd2eVJyif3NhcowFIWqR7dGIbDRX5ZoKtlQL0JMVX5
         5Sm0pY0VrkGCWpmbui23/IWGuibqg9T1i1cys=
MIME-Version: 1.0
In-Reply-To: <20090826061241.GC6194@elte.hu>
References: <20090824175335.186713800@openvz.org>
	 <20090824175551.322214127@openvz.org> <20090826061241.GC6194@elte.hu>
Date: Wed, 26 Aug 2009 10:22:22 +0400
X-Google-Sender-Auth: 34eb21307bbbd31d
Message-ID: <aa79d98a0908252322j3b98c4dbs9b45e6f3147496a8@mail.gmail.com>
Subject: Re: [rfc -tip 3/4] x86,apic: fix missed handling of discrete apics
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
>> +	if (!cpu_has_apic && (!smp_found_config || disable_apic))
>> +	if (!cpu_has_apic && (!smp_found_config || disable_apic))
>> +	if (cpu_has_apic || (smp_found_config && !disable_apic))
>
> these are now repeating patterns, so that should be moved into a
> helper inline or so.
>
> 	Ingo
>
Absolutely yes. Though i didn't invent more or less convenient name
for this helper. lapic_from_mp perhaps. Have to think. Thanks for
review, Ingo!
