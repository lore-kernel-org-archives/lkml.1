Return-Path: <linux-kernel-owner+w=401wt.eu-S1161340AbXDVQKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340AbXDVQKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161337AbXDVQKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:10:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:62061 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161340AbXDVQKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PeYBdfmKM87oSp0dBpmrAAVBjuSWMGOKXBQOssd2bcEB3s5JBR59YHfl9gGQQRgkzyNr5yWOL1Tv0qtWuj+IhSD7QJrhY8JR7CrCKf7L4g3lPV6Tw9ah5v9kXhZYmibXuV2PeLYhFsjZ7SKU70GP1MM1oXbbkQ8ykV8o8rMeLpg=
Date: Sun, 22 Apr 2007 18:11:46 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: linux-kernel@vger.kernel.org, oliver pinter <oliver.pntr@gmail.com>
Subject: Re: [BUG? -rc7] SMP: Just one CPU activated: P4 3GHz HT
Message-ID: <20070422161146.GA7924@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653402b90704220538gf0041f1yf699cc8aa5f200e8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ojeda <maxextreme@gmail.com> ha scritto:
> On 4/22/07, oliver pinter <oliver.pntr@gmail.com> wrote:
>> I have CC the kernel
> 
> Did you?
> 
>> and the result is:
>>
>> your'e config : failed smp
>>
>> your'e config + power managment : ok
>>
> 
> Interesting, can anyone tell me why does not SMP work without Power
> Managment? Should it be that way?

Probably the two siblings are enumerated only in ACPI tables. If you
disable ACPI the kernel won't be aware of the second "core".

Luca
-- 
"Su cio` di cui non si puo` parlare e` bene tacere".
 Ludwig Wittgenstein
