Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbXFYSVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbXFYSVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXFYSUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:20:55 -0400
Received: from mail.mimer.no ([213.184.200.1]:47784 "EHLO odin.mimer.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXFYSUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:20:54 -0400
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 14:20:53 EDT
From: Harald Arnesen <harald@skogtun.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       david@lang.hm
Subject: Re: Linux Kernel include files
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	<Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	<467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	<1182483527.10524.31.camel@shinybook.infradead.org>
	<467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
	<1182785277.12109.121.camel@pmac.infradead.org>
Date: Mon, 25 Jun 2007 20:04:41 +0200
In-Reply-To: <1182785277.12109.121.camel@pmac.infradead.org> (David
	Woodhouse's message of "Mon, 25 Jun 2007 16:27:57 +0100")
Message-ID: <87wsxrdi6e.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

>> >  Can you be more specific about why this is a problem? Don't
>> > we mostly define those crappy types using arch-specific knowledge, as
>> > 'int', 'long', etc?
>> 
>> I recommend you to install Sun Studio and to try to compile star or cdrtools
>> using Sun Studio by calling "make CCOM_suncc".
>>
>> ftp://ftp.berlios.de/pub/star/alpha/
>> ftp://ftp.berlios.de/pub/cdrecord/alpha/
>> 
>> You may need to hand edit the file incs/<arch-dir>/{xconfig.h!rules.conf}
>> 
>> in order to enable the auto-disabled features.
>> 
>> In any case, self reading the error messages from Sun Studio helps more than
>> trying to discuss it.
>
> I have no interest in doing this for myself, and I suspect that if I
> tried it I'd find that Sun Studio doesn't exist for Linux/PowerPC
> anyway. Please just show the error messages.

Apart from the usual whining about GNU make, the error message is:
make: *** No rule to make target `CCOM_suncc'.  Stop.

If I actually install smake, as Jörg recommends, the message becomes:
smake: Can't find any source for 'CCOM_suncc'.
smake: Couldn't make 'CCOM_suncc'.
-- 
Hilsen Harald.

