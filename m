Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZJ2Wet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZJ2Wet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZJ2Wer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:34:47 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63306 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbZJ2Wel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VO5VxZJRFoz5u0wjONRRf+d3UUwIId5m2ZXFMRdqMILA63mZZEteERzD9jwZaoR1vP
         EZH51wABkrgup6YuzuAb5ZifU5TQxqx2h6PvGavBBoCRGeYGW/gieWcajH4socqvUKBm
         0gP8h31IfYfpl3Na2Zyonuxk+hMxNt4N3Vicc=
MIME-Version: 1.0
In-Reply-To: <20091029222335.GJ18464@mit.edu>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.haF.Are5KB@chimera>
	 <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
	 <20091029222335.GJ18464@mit.edu>
Date: Thu, 29 Oct 2009 18:34:45 -0400
X-Google-Sender-Auth: 0448fd16da2bde27
Message-ID: <cb0375e10910291534j485b9e55vc42c3ce94a30252c@mail.gmail.com>
Subject: Re: [Bug #14472] EXT4 corruption
From: Andrew Lutomirski <luto@mit.edu>
To: Theodore Tso <tytso@mit.edu>, Andrew Lutomirski <luto@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shawn Starr <shawn.starr@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 6:23 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Oct 29, 2009 at 03:57:32PM -0400, Andrew Lutomirski wrote:
>>
>> This but is *not* fixed.  I just triggered it a few minutes ago by
>> abusing i915 and drm, which caused a panic.  This is slightly newer
>> than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.
>
> Andrew, can you test to see if this patch helps?

I'm building a kernel with that patch now, and I'll keep running it
for awhile.  I only seem to trigger this bug once a month or so, so
I'll let you know if I see any more corruption.

Thanks,
Andy
