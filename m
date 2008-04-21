Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYDUUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYDUUeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYDUUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:34:13 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55904 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYDUUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:34:12 -0400
Message-ID: <480CFA42.20408@keyaccess.nl>
Date: Mon, 21 Apr 2008 22:34:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: What pokes the ISA IO port of 0x211 ?
References: <480C92C9.18283.A24BB91B@localhost> <480CF3A5.8080104@keyaccess.nl>
In-Reply-To: <480CF3A5.8080104@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-04-08 22:05, Rene Herman wrote:

> On 21-04-08 13:12, Frantisek Rysanek wrote:
>> Dear Everyone,
>>
>> I'm dealing with an embedded PC motherboard that contains some custom 
>> circuitry (GPIO), accessible via an ISA IO range between 0x200 and 
>> 0x218. 
>> There's an interesting issue with this in recent Linux (tried 2.6.22.6 
>> and 2.6.24.2): something probes IO port 0x211 on boot, which happens 
>> to be an add-on buzzer control port - effectively the kernel boot 
>> launches an accoustic alarm :-) 
>> Any ideas what this could be? 
> 
> ISAPnP default read data port is close at 0x213...
> 
> I haven't checked but this also reminds me of sensor chips. Do you have 
> sensor drivers builtin?

Ah, it's the old analog gameport: ns558_init.

Rene.
