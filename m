Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZK1IrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZK1IrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 03:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZK1Iq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 03:46:59 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47439 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZK1Iq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 03:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=apgmaTVyu/gAtO9XksgpcDYGYVowsg1H7yxO+9MLBfzIX8F/0CtOiHYs17CxyCWgj4
         ONXvMVx4I/7iH4jGy5iMRJIEwjX3Cpoxyv27m3fgi1vTwqxLuhG5o+7RgXj0x5/jQjCG
         +iPi/b2zmPCfxvIUaeW7xm1XdrHTjnPJlWaec=
Message-ID: <4B10E385.1030900@gmail.com>
Date: Sat, 28 Nov 2009 09:47:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3 16/27] PPC: use helpers for rlimits
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>	 <1259363167-9347-16-git-send-email-jslaby@suse.cz> <1259367557.2076.11.camel@pasglop>
In-Reply-To: <1259367557.2076.11.camel@pasglop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2009 01:19 AM, Benjamin Herrenschmidt wrote:
> On Sat, 2009-11-28 at 00:05 +0100, Jiri Slaby wrote:
>> Make sure compiler won't do weird things with limits. E.g. fetching
>> them twice may return 2 different values after writable limits are
>> implemented.
>>
>> I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
>> applicable.
> 
> Thanks. I have that already queued up.

Are you sure? The previous version with ACCESS_ONCE was generally
NACKed. This one uses a newly added helper which is much more cleaner
way to do it.

thanks,
-- 
js
