Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbYEFMqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbYEFMqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYEFMqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:46:36 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35207 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYEFMqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:46:35 -0400
Message-ID: <48205360.7000508@keyaccess.nl>
Date: Tue, 06 May 2008 14:47:28 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Pete Clements <clem@clem.clem-digital.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Lost Sound from 2.6.24 to 2.6.25 -- CS4236 ISA
References: <200805051406.m45E6pta001929@clem.clem-digital.net> <s5hfxsvd31h.wl%tiwai@suse.de>
In-Reply-To: <s5hfxsvd31h.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 14:34, Takashi Iwai wrote:

> At Mon, 5 May 2008 10:06:51 -0400 (EDT),
> Pete Clements wrote:
>> Looks like sound card stops functioning between
>> 2.6.24 and 2.6.25.
> 
> Could you elaborate what do you mean exactly "stop"?  Fail to load or
> initialize the driver, or silent output, DMA error...?
> 
>>  Sorry but don't know at what
>> point.  Card is an isa CS4236. Glad to provide
>> any other info/testing.
> 
> Any relevant kernel messages are welcome.  Also, if you passed any
> (module) options for the sound driver, show it, too.
> 
> The biggest change in ISA sound driver codes between 2.6.24 and 2.6.25
> is that we dropped the PnP resource re-configuration via module
> options of sound drivers.  They have to be adjusted via sysfs now 
> (if really needed).
> 
> Otherwise, if it really worked on 2.6.24, we have a good chance to
> identify the affecting changeset via bisect.  There are only a few
> changes for sound/isa.

For what it's worth and as a preliminary comment, snd-cs4236 is my main test 
driver and works fine for me.

Rene.
