Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXE2MAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXE2MAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXE2MAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:00:30 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:46325 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXE2MA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=E2jwtUa3NjTsMx/1mo2i2mcIbGDbnui2Y4shOVwl1RDaWIrsqO2g0ddH0hHGsK0Iytf8iLdjCOi+A4gAE3bal6HOB1SZaZjh+0ZeMQ5q96NaHKh4k4F4pHHzOlrZwMJC6Wk/wwR0XnVTFMQJOhOAi1KKG6IkRi3tbXp4XTLjZQU=
Message-ID: <465C15D9.3070905@gmail.com>
Date: Tue, 29 May 2007 13:00:25 +0100
From: Michael-Luke Jones <mike.luke.jones@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
References: <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org> <3ae72650705282355j40a0b03bt96661bc1263efc35@mail.gmail.com> <200705291400.46707.rjw@sisk.pl>
In-Reply-To: <200705291400.46707.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 29 May 2007 08:55, Kay Sievers wrote:
>> The shiny userspace firmware loading causes problems since it exists,
>> every second box has problems with it, in all sorts of situations. If
>> people are still sold to the idea of userspace firmware loading, why
>> don't we keep the data in the driver, instead of immediately
>> discarding it after the first upload? Not to waste a few hundred
>> kilobytes? That doesn't sound like a convincing deal, after all the
>> years people try to work around the issues it causes.
> 
> Agreed.
> 
> Rafael

Rather than most drivers being told to make this step, can this be added 
to the firmware_class such that firmware objects are cached in RAM and 
subsequent calls to request_firmware() don't have to query userspace.

This seems the least intrusive solution to this problem.

Thanks,

Michael-Luke
