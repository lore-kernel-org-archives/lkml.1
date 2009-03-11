Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZCKWb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZCKWb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZCKWbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:31:49 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:35445 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZCKWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rXLhYtNMz2TfwbZvRlqXKGOuJQ8D+8dknAPnLy6P0Z6RtyIFdQscbRBqZoSk2gZr95
         DyxujO9Z1yUzgyDxOhlaQSijiWUxKxQKvz0BY+2O0LrS1LQqaYcpKfIpC9gYbErvPVQH
         8HM7uj80f1l9OYCfJRA59FmlqRfv2yBlgwvWw=
Message-ID: <49B83BCE.4010908@googlemail.com>
Date: Wed, 11 Mar 2009 23:31:42 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Ivo_R=F6ssling?= <ivo@wettinet.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.27.7 runs into Kernel Panic on Shuttle X27D with Intel
 Atom 330
References: <49B7F502.10603@wettinet.de>
In-Reply-To: <49B7F502.10603@wettinet.de>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I experienced a kernel panic when trying to install the OpenSuSE 11.1
> [x86-64] on my new Shuttle X27D with an Intel Atom 330.

Nice device - I own one of them, too. And it's been running for weeks
without any problems.

> The manual of the Shuttle X27D is not all too verbose, so I cannot say
> much about the chipset or BIOS yet. (But I might find out whatever may
> be important. It's just that I don't have it at hand right now...)

The chipset is an ordinary 82945G-something with integrated graphics and
ICH7 southbridge (not the power-saving one that is used for embedded
Atoms, unfortunately).

> When I boot the Install DVD of OpenSuSE [x86-64] and chose "Install"
> without changing any option, I run into the following error:
> 
> ---------- snip ----------
> BUG: unable to handle kernel paging request at ffffffff80209000
> IP: [<ffffffff80246bc>] on_each_cpu+0x0/0x30
> PGD 203067 PUD 207063 PMD 7dfc6163 PTE 209161
> Oops: 003 [1] SMP
> last sysfs file:
> CPU 0
> Modules linked in:
> supported: Yes
> Pid: 1, comm: swapper Not tainted 2.6.27.7-default #1
> ---------- snap ----------

Just checked it - same here (original German Suse 11.1, out of the box).

I'm running a self compiled system with vanilla 2.6.27 (x86_64) from
kernel.org, however, and that works fine. Even with the original BIOS.
And I had no problems with the Realtek ethernet chip either. I suppose
it's the Suse kernel.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
