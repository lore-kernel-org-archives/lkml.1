Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYCTLer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYCTLer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 07:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbYCTLeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 07:34:37 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:51279 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYCTLeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 07:34:36 -0400
Message-ID: <47E24C0F.1070901@keyaccess.nl>
Date: Thu, 20 Mar 2008 12:35:43 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alessandro Suardi <alessandro.suardi@gmail.com>
CC: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>	 <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl>	 <200803171855.44552.david-b@pacbell.net>	 <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>	 <47E1B062.4060709@keyaccess.nl> <5a4c581d0803192208w6db8f2aaj42eac883de126585@mail.gmail.com>
In-Reply-To: <5a4c581d0803192208w6db8f2aaj42eac883de126585@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-03-08 06:08, Alessandro Suardi wrote:

> On Thu, Mar 20, 2008 at 1:31 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:

>>  I do wonder -- is your hda throughput also the same before _ever_ attaching
>>  anything to the EHCI controller and after? In my case, the slow down only
>>  happened after switching on my external USB drive once, and would persist
>>  from that time until reboot (or unloading ehci-hcd, which I kept modular for
>>  exactly that reason).
>>
>>  The sleep time wasn't the core problem, so I wonder of later VIA chips do
>>  still have the active async schedule problem...
>>
>>  Alessandro? You said there still was a difference for you between no EHCI at
>>  all and EHCI after tweaking 4B as Lev showed. How much?
> 
> When used setpci to tweak the setting, my hdparm -t went
>  from 17 to 25MB/s on /dev/hda.
> 
> With your patch applied, now after booting it says 33MB/s for
>  hda and 37MB/s on hdb (and I can burn DVDs at a stable 6x
>  now, while growisofs backed off to 4x in less than a minute
>  before the patch).
> 
> If the patch does exactly what setpci did, then perhaps I had
>  other activity on hda at the moment I ran the test...

Yes, should be the exact same. It could be what I noted -- that you have the 
33/37 just after booting, and a drop to 25 again after having switched 
on/used a EHCI device for the first time? That would be interesting.

Rene.
