Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXCSV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXCSV5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030687AbXCSV5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:57:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624AbXCSV53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:57:29 -0400
Message-ID: <45FF06DA.9010500@redhat.com>
Date: Mon, 19 Mar 2007 17:55:38 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg KH <greg@kroah.com>, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 29/31] Input: i8042 - fix AUX IRQ delivery check
References: <20070319213047.710101653@mini.kroah.org>	 <20070319213647.GB9261@kroah.com> <20070319214108.GE9261@kroah.com> <d120d5000703191448m67c1afcnc3340c956ef7a25a@mail.gmail.com>
In-Reply-To: <d120d5000703191448m67c1afcnc3340c956ef7a25a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 3/19/07, Greg KH <gregkh@suse.de> wrote:
>> -stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>>
>> From: Dmitry Torokhov <dtor@insightbb.com>
>>
>> Input: i8042 - fix AUX IRQ delivery check
>>
>> On boxes that do not implement AUX LOOP command we can not
>> verify AUX IRQ delivery and must assume that it is wired
>> properly.
>>
> 
> Greg,
> 
> There is another piece missing in AUX delivery test, commit
> 
>    3ca5de6dd4ec5a139b2b8f00dce3e4726ca91af1
> 
> Unfortunately I can't send you a patch at the moment but if you could
> get it from the mainline that would be great.
> 

I was going to send that but wasn't really sure if I should.
Next time I'll just send everything I have...



