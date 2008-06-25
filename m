Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYFYMZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYFYMZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYFYMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:25:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:11540 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYFYMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f9KXuiLR280xMOtNfnyv4MtG1CRkHGhM8N3cUMwWKxCAWBAzIw/luEcL5OTb8LLAtQ
         Yf70d9XrouSYeyvy1RyAf+B3h8KOrPEfGSXBIqoNHWOR8NEmXV1DRhlCRUECC1+/tsIj
         IQv1I50y/lvuhICm83hV0uDCYA1vnEma6a3FY=
Message-ID: <cfd18e0f0806250525h26bb595bhe897c0d2fcf4e381@mail.gmail.com>
Date: Wed, 25 Jun 2008 14:25:36 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: "Ingo Molnar" <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>,
       "Bart Van Assche" <bart.vanassche@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0806251421580.3297@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
	 <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
	 <alpine.LFD.1.10.0806250900240.3297@apollo.tec.linutronix.de>
	 <cfd18e0f0806250520u565d512as298f024df06da857@mail.gmail.com>
	 <alpine.LFD.1.10.0806251421580.3297@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 2:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 25 Jun 2008, Michael Kerrisk wrote:
>> > Hmm, that's a bit backwards. We changed the internal handling of those
>> > interfaces to hrtimers in 2.6.16, but the accuracy is still jiffies
>> > unless you have CONFIG_HIGH_RES_TIMERS enabled (which is only possible
>> > as of 2.6.21) and your system provides the necessary hardware.
>>
>> So then it's simply enough to say:
>>
>> Since  Linux  2.6.17,  Linux  optionaly supports  high-resolution  timers
>> (configurable via CONFIG_HIGH_RES_TIMERS).
>>
>> right?
>
> Make this 2.6.21 :)

D'oh!  Yes of course.  Fingers were working, but Mr. Brain had long
since departed...

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
