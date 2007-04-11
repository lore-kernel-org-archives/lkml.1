Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXDKUcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXDKUcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXDKUcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:32:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:27197 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXDKUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bRP+1vTDtXPigHN/8RKF7yKtD8CR4NwF8CEpgXt/Pj/pSKNsbVkHBw3GbUpA/e/ng5s0s3CBLaAKMmyqOoXldKZnfsvv7g1BeJ6NWYnl+KMpp1AlP8fQDPfsZNq1TE67/aLuXTmaRm1ODeuvrytk/Lz7C0b8tZcqNkwtPo67cOM=
Message-ID: <461D45CE.3030309@gmail.com>
Date: Wed, 11 Apr 2007 22:32:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
References: <2189310342910921713@karneval.cz> <20070411132053.899462b4.akpm@linux-foundation.org>
In-Reply-To: <20070411132053.899462b4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Wed, 11 Apr 2007 15:04:35 +0200 (CEST)
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> @@ -706,6 +718,8 @@ static int get_lcd_state(void)
>>  {
>>  	int lcd = 0;
>>  
>> +	BUG_ON(!hotk->methods->lcd_status);
> 
> mutter.  We could just warn-and-bale here.
> 
> Hopefully this is just an is-jiri-sane assertion and it should never happen,
> no matter how busted the BIOS tables are?

Exactly :). Only if somebody changes the code around, so that it is called
with the method unset, it triggers and in that case it's definitely a bug.

Side note, as Danny wrote, there is an asus-laptop driver sitting in -mm,
which supersedes this one -- if you plan to push it upstream in the near
future, don't bother with this patch.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
