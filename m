Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbXBOQCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbXBOQCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966000AbXBOQCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:02:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:38118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961AbXBOQCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=M/dJsvJprkTQpSy1C8p7DSrv8leFIW1nUsYUtaR0cYA8bM02HLNUJtauPflinKQ90HZ6CDADnW+gz9UmhoAgEaSH+Vzoo7Ct/J+cc3lbw0Ek8zbCmHYDfyvXl1H48XS5NNsssJgJGAP9j/I43Lj3W2/PQe0sZqQfaPMMa+jcXTk=
Message-ID: <45D3E854.6020701@gmail.com>
Date: Thu, 15 Feb 2007 13:57:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Patrick Ale <patrick.ale@gmail.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: libsata tests started
References: <8d158e1f0702100822i28d0bcds91cf27fc34534d2c@mail.gmail.com>	 <20070210114155.6f7433c8.randy.dunlap@oracle.com>	 <8d158e1f0702101214j603e1880i7eae2d94b446bc0b@mail.gmail.com>	 <20070210203504.129b35ac@localhost.localdomain>	 <8d158e1f0702101232q244a890fg450aa039689fcb3a@mail.gmail.com>	 <8d158e1f0702101404s457fd1fx72f838021d7831b7@mail.gmail.com>	 <6bffcb0e0702101423xd854b59x22d1d08f89ffa42c@mail.gmail.com> <8d158e1f0702130031n75926241q83733cceb4080aa9@mail.gmail.com>
In-Reply-To: <8d158e1f0702130031n75926241q83733cceb4080aa9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> So, my AMD Athlon XP2400+ with pata_pdc2027x, pata_sil680 and pata_via
> Now, since functionality by design is boring and my employer doesn't
> torture me enough,, I' pulled the libsata-dev git and linux-2.6 git
> and will see how that goes.

It's libata.  I mean, you yourself are testing several PATA drivers.

> Tests on my Siemens laptop are still in progress, since i have to
> reboot to windows every day (cooperate rules at work, network
> authentication, yadayada).
> 
> I didnt have time yet to install Linux on my HP Pavilion dv8373 and on
> my Dual P2 400Mhz with Intel 440BX motherboard, but I hope to do this
> soon.
> 
> Have a joyfull day and i hope you have better weather than we have
> here in Amsterdam.

I appreciate the testing.  One interesting but tedious test would be 
suspend tests (both to disk and ram).  Most libata drivers using new EH 
should be ready for them.  Oh, well, there's should and there's reality.

Thanks a lot.

-- 
tejun

