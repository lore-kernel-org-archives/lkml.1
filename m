Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYCVINi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYCVINi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 04:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYCVINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 04:13:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:16982 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYCVINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 04:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=p1uFhjctkmSLsBP6nNkQ4bTEqQLA5rkfg+SEuPD/QSADXFBXsmLTn95Zg1pBu78PynH5IH/n9gK8M963Miqu3VMMsAR+irLlI491Y09EKZfgVF/7Ra68LBeXWSEI3rzIsvAaiJ3SqSSsHrGEIF8JDUzwruajCy0tsVvPOxzwvfU=
Message-ID: <47E4BF9D.8020405@gmail.com>
Date: Sat, 22 Mar 2008 17:13:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
CC: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
References: <20080214184700.0bd3837d@highlander.home.lan> <47B4D02E.9030101@gmail.com> <20080215191215.430ee2e0@highlander.home.lan> <47BCE71F.2000309@gmail.com> <20080221172757.44882428@highlander.home.lan> <20080317210045.GG3189@fi.muni.cz> <20080318140116.GC8480@fi.muni.cz> <47E08762.9090704@gmail.com> <20080319061958.GK3189@fi.muni.cz> <47E0B46C.6030302@gmail.com> <20080321164320.GA32699@fi.muni.cz>
In-Reply-To: <20080321164320.GA32699@fi.muni.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kasprzak wrote:
> Tejun Heo wrote:
> : Jan Kasprzak wrote:
> : > Tejun Heo wrote:
> : > : Hmm... I still wanna know why it got broke in the first place.  The only
> : > : thing I can think of is IRQ routing problem in which case pci=nomsi or
> : > : irqpoll should help.  Any chance you can test the old BIOS?
> : > 
> : > 	Yes, I can. What data are you interested in? Boot logs with
> : > pci=nomsi and irqpoll ? Anything else?
> : 
> : pci=nomsi, then, irqpoll should be enough for now.
> : 
> 	I have tried to do this, but unfortunately ASUS BIOS flash
> utility does not let me to downgrade to the 0906 bios, where the problem
> occurs. It lets me only downgrade from 1101 to 100x, but not to 0906
> (even when called from the 100x BIOS).

Eee... Let's hope someone else reports again.

Thanks for the trouble.

-- 
tejun
