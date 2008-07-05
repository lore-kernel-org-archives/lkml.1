Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYGERzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYGERzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYGERlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:41:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:55887 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbYGERlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hfmlWVTPFgAhlBCWhuXTPTwzLvHKf0Y83sZTbtf3CnNFD1WQ5DR7LhdWnHWoABXdri
         L+RaaNdioZhh6pRbNqXsTEwd0Igc+eb3Wp0w05D19S0vNsP4FKudEXNs2HrMp1dQQMq4
         nnLwA87EbPl08aU99erdxsrj6Hk2gaBPXzHo8=
Message-ID: <31e679430807051041w6dd9b917xc51f31f66fbd65d3@mail.gmail.com>
Date: Sat, 5 Jul 2008 20:41:07 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Battery life difference
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080705085432.2f9b2964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
	 <20080705082352.4b6be669@infradead.org>
	 <31e679430807050844r30ff74fby7e15641573b42d82@mail.gmail.com>
	 <20080705085432.2f9b2964@infradead.org>
X-Google-Sender-Auth: be1a2663638ee828
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 5, 2008 at 6:54 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> you may also need to toggle your bios to enable AHCI btw
>
>>
>> > Also take a look at
>> > http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024
>> > because these patches save like 0.75W in our lab.
>>
>> cool, is it merged upstream ?
>> I'll build current git kernel and reply again with new linux results.
>> It could be that ubuntu 2.6.24 is broken somehow...
>>
>> > To be honest, I'm surprised at your results; in our testing (with a
>> > different distro though) we don't see such a difference and Linux is
>> > doing rather well.
>>
>> can you get powertop results in a 2.6.24 distro kernel and current git
>> kernel ?
>
> most of my measurement machines are in the office ;(
>
> Anyway, also make sure you use the 0.11 version of powertop; we added
> some newer stuff into that version...

Cool, now I'm using current linux 2.6.26-rc8 from git
b8a0b6ccf2ba2519ace65d782b41ee91bf3c3778

Now I'm reaching 9.8w consumption :-)

Really good improvements.

btw, any plans to move some of the powertop features to acpid ?
I mean, the wireless pm for iwl4965 could be there, couldn't it ?

I'll anyways clone linux-acpi tree and try to test recent patches
as much as I can, although omap is really eating my time.

thanks again Arjan.

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
