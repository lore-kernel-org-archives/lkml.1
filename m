Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXFGPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXFGPyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765580AbXFGPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:54:07 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:38587 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765973AbXFGPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=He56IWjtSp3U0Xbxi0ui/RWVfxyLprhL3ClFK2HRgmPhfuYoghcGVM5GNEBuYp0CYR5JDPWgyufwOtJbaDTBaHb0AEd3mvEkOCxm2jOM5ocV6uGhIz7Dzs1VNyf/joA94cEX2j5AIo0VJ1NQc5W3C3uv5kjGxT4s/A4Imu+Z2qg=
Message-ID: <46682A25.5070409@gmail.com>
Date: Thu, 07 Jun 2007 17:54:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com> <4667AD3F.1010405@gmail.com> <4667AF20.4020209@gmail.com> <4667B095.5050508@gmail.com> <4667B241.801@gmail.com>
In-Reply-To: <4667B241.801@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo napsal(a):
> Jiri Slaby wrote:
>> Tejun Heo napsal(a):
>>> Jiri Slaby wrote:
>>>> Yes. Now I'm compiling -rc4-mm2.
>>> It's probably caused by new sysfs slimdown patches and I'm pretty sure
>>> -rc4-mm2 would fail the same way.  The offending one should be one of
>>> the following patches.
>> There's reverted gregkh-driver-block-device in -mm2. So I wanted to give it a
>> try. Do you think it's pointless and that patch has no impact on the behaviour?
> 
> I'm not familiar with how lvm vgscan works and the patch does look like
> it can affect that.  Please give a shot at -mm2.

Yup, it works without any further patches. So it seems like
gregkh-driver-block-device is the culprit?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
