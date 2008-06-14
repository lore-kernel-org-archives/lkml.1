Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYFNTXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYFNTXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 15:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYFNTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 15:23:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:65062 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYFNTXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 15:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OFJfpEarK9/pEhL5Au7uhLjrA/3g5c1yaMGau6zo/YiRhZQXC1SkERXPlgRvRWpxOX
         91ahFN4Eu+2KSEOzhLjSaDztyKs8M4BHopg680UzngQEsOpExt4gjxHifhi9hAchrINq
         3GQz5QxLzudGl6hoU+VXHKI/01+JO/XNUAt50=
Message-ID: <e2e108260806141223l3545ea5ao2dc76325259bd3e8@mail.gmail.com>
Date: Sat, 14 Jun 2008 21:23:23 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Marco Barbero" <marco.barbero@gmail.com>
Subject: Re: OOM killer invoked on 2.6.24.4
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e1aa27e00806141034k6bab05f9g5ac01ed478a1e78f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1aa27e00806140313o5a62c618kb41b892b7b29e235@mail.gmail.com>
	 <e2e108260806140831s40f36a95s1a412cec4dc47f31@mail.gmail.com>
	 <e1aa27e00806141034k6bab05f9g5ac01ed478a1e78f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 7:34 PM, Marco Barbero <marco.barbero@gmail.com> wrote:
>> One or more processes on your system used too much memory. Dumping the
>> output of the following command periodically (e.g. every 10 minutes)
>> to a file will tell you which process is using too much memory:
>
>> { ps aux | head -n 1; ps aux | sort -n +4 | tail -n 10; }
>
> I'll do it.  Have to say that this box had an uptime of 1 month and
> never show issues. Also oom was invoked in the night when load is
> minimum.
> Could be related to slab and the quicklist leak?

Are you running the kernel in 32-bit mode ? Wouldn't it be better to
run a 64 bit kernel with 4 GB RAM ?

Bart.
