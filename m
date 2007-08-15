Return-Path: <linux-kernel-owner+w=401wt.eu-S1764776AbXHOKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764776AbXHOKCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbXHOKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:02:23 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:39177 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbXHOKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:02:23 -0400
Message-ID: <46C2CE42.4010303@gmail.com>
Date: Wed, 15 Aug 2007 11:58:26 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr> <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2007 11:20 AM, Jan Engelhardt wrote:

> On Aug 15 2007 10:37, Rene Herman wrote:
>> On 08/15/2007 09:28 AM, Jan Engelhardt wrote:
>>> On Aug 14 2007 16:21, Jason Uhlenkott wrote:
>>>> On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:

>>>>> NULL is not 0 though.
>>>> 
>>>> It is.  Its representation isn't guaranteed to be all-bits-zero,
>>> 
>>> C guarantees that.
>> 
>> C guarantees what? If you're disagreeing with Jason -- he's right.
> 
> http://coding.derkeiler.com/Archive/C_CPP/comp.lang.c/2003-11/1808.html

He said the null _pointer_ isn't guaranteed to be all-bits zero. And it 
isn't. Read the standard or the faq.

>>>> but the constant value 0 when used in pointer context is always a
>>>> null pointer (and in fact the standard requires that NULL be
>>>> #defined as 0 or a cast thereof).

Rene.
