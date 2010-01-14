Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246Ab0ANCCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0ANCCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885Ab0ANCCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:02:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:47994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0ANCCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:02:39 -0500
Message-ID: <4B4E7B0B.6050305@suse.com>
Date: Wed, 13 Jan 2010 21:01:47 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] virtio: fix section mismatch warnings
References: <20100113004855.550486769@suse.com>	<20100113004939.463885987@suse.com>	<201001132127.26873.rusty@rustcorp.com.au> <20100113170744.b45c9220.akpm@linux-foundation.org>
In-Reply-To: <20100113170744.b45c9220.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2010 08:07 PM, Andrew Morton wrote:
> On Wed, 13 Jan 2010 21:27:26 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> On Wed, 13 Jan 2010 11:19:01 am Jeff Mahoney wrote:
>>>  This patch fixes the following warnings by renaming the driver structures
>>>  to be suffixed with _driver.
>>>
>>>  WARNING: drivers/virtio/virtio_balloon.o(.data+0x88): Section mismatch in reference from the variable virtio_balloon to the function .devexit.text:virtballoon_remove()
>>>
>>>  WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x88): Section mismatch in reference from the variable virtio_rng to the function .devexit.text:virtrng_remove()
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>
>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>>
>> Andrew, will you take these?
>>
> 
> umm, sure.  But I wish I knew how the patch worked.  Is there some
> magic sauce which moves a variable called foo_driver into a different
> section or what?
> 
> And if so, what was I doing when that got done :(

It doesn't move it into a different section, it just shuts the warning
up. modpost has a whitelist it uses to ignore the mismatch warning.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAktOewsACgkQLPWxlyuTD7IGKgCfSETonDGCsM/AgsUmdGtvSzCi
omQAn3tMc0Ol6PkpaX0Qf6+tvcUnlqcU
=jUja
-----END PGP SIGNATURE-----
