Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbYAVCIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbYAVCIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 21:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYAVCIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 21:08:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:9628 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbYAVCIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 21:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UQrECeFwylZwGF3uU5ysxuLTKXvyupQ1kSBS0g13IrW0RoHDrQuJhmY4hRtD0Lyd+2riycxKaM7ZC5l6wGP0sDxj4zzc2vkaPtf7Po5qmjjEMuFrtCcRJvpT0Aqd9SxBYiqzMX8jdqa5hiw1rj/rr2bj53lPL1d7hBxsF9hPSiA=
Message-ID: <47955018.7000901@gmail.com>
Date: Tue, 22 Jan 2008 11:08:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
References: <200801140019.20668.g.chulkov@jacobs-university.de> <20080121164744.2f7d0ed1@lxorguk.ukuu.org.uk> <4794D020.4060204@gmail.com> <200801220231.22609.bzolnier@gmail.com> <4795488E.30706@gmail.com>
In-Reply-To: <4795488E.30706@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Bartlomiej Zolnierkiewicz wrote:
>> On Monday 21 January 2008, Tejun Heo wrote:
>>
>> [...]
>>
>>>> Old IDE says it works for PATA. For SATA I can see it might need more
>>>> care and you might simply not be able to get the info.
>>> Old IDE often locks up the machine hard after timeouts.  I'm all for
>> Could you point me to some bugreports?
>>
>> I would like to know more about hosts/conditions for which it happens.
> 
> It's jmicron and all on-board jmicrons I have show the same problem.
> Connect harddrrive to the controller and drive it via jmicron, hot plug
> unplug SATA drives continuously, after a while, jmicron says it lost
> interrupt and the machine locks up hard.

BTW, those hot plug/unplugs don't have any direct relationship with the
JMB controller.  It's some interference or power issue, I guess.  Hot
plugging unrelated drives somehow locks up the jmicron driver.  :-(

-- 
tejun
