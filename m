Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZLKRtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZLKRtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZLKRta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:49:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57824 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZLKRt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FsqUHgm4E+0/v692L9K+AeOgHV8vW8yz/730/QSOcEVmXBIilSPA09qeqahKhAI3P+
         W6Oastkv0X8ymQUMigkdk1mYO2il2s+ESVkX+3NAjGPRJRq9nFRsef7qOy67ywcGlCnF
         1MmxwZLFDAC5f7l0bw+ilNEHgx+Yyw7cUuytQ=
Message-ID: <4B22862E.5050407@garzik.org>
Date: Fri, 11 Dec 2009 12:49:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie> <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain> <1260459601.18520.26.camel@skunk> <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain> <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com> <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain> <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com> <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain> <20091210235835.20e2269d@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain> <20091211091843.0a543136@lxorguk.ukuu.org.uk> <4B221EDA.5020902@garzik.org> <alpine.LFD.2.00.0912110710510.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912110710510.3560@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 10:28 AM, Linus Torvalds wrote:
>
>
> On Fri, 11 Dec 2009, Jeff Garzik wrote:
>>
>> F11 uses nouveau here.  It is actually a pain to get 'nv' going as an
>> alternate -- bugs have been filed.  Makes kernel dev more difficult for me.  I
>> was actually told, by Fedora people, that I should be hacking on the Fedora
>> (rpm-based) kernel, rather than a 100% upstream kernel like I have been
>> hacking/booting for the past decade, as a result of this setup (needing
>> nouveau kernel support, thus needing Fedora rather than upstream kernel).
>
> Btw, for all my ranting (and maybe Alan is right, and I'm ranting at the
> wrong people - it's just that the actual driver authors aren't the ones
> that violated any rules), I do have to give kudos for the fact that the
> F12 situation seems to be much better.
>
> These days, what you can do is basically do all development (assuming it's
> not nouveau development) in the upstream kernel, and then you just have a
> separate 'nouveau' git tree (or branch) that you pull in the nouvea stuff
> into.
>
> That tree/branch will be a mess of random merges-of-the-day, but you'll
> never push it out to anybody anyway, so nobody cares. And building that
> messy merge tree will get you a working setup without any extra steps - a
> simple "make modules_install ; make install" will JustWork(tm).

At the outset, I was hoping for an even more straightforward solution: 
"if nouveau kernel mod not present, fall back to nv"  That would work 
without any kernel modifications at all.

But the answer came back as "if you run Fedora, run a Fedora kernel, 
otherwise don't expect anything to work"  My experience directly 
contradicts claims of "upstream first" policy, both in code and attitude.

I am looking into doing the git tree merge you suggest right now....  I 
didn't know that was an option, given ongoing API changes.  That would 
make my life quite a bit easier.  As you note, anything graphics is 
_glacially_ slow due to vesa fallback, when using a 100% upstream kernel.

	Jeff


