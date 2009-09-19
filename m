Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZISWI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZISWI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZISWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:08:57 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:45702 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZISWI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:08:56 -0400
X-Greylist: delayed 46108 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2009 18:08:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JN3V7t/4EwimuAgzRwNn9N1nT/CYVLbWRKvxBMCFiUvbkUfhafLEfcc2TQ+luhPfqy
         k/bCnxRm4y1hOZlaAH9m4cdTb2MmRLWUk9avlPH309gOTD5M4U4dTlzKQfGCsfFTZmVJ
         7TxDed/eOd8h1ogzne5lOJffHZhWgdmBmfMJg=
Message-ID: <4AB55679.7010300@gmail.com>
Date: Sun, 20 Sep 2009 00:08:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.6 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Hibernation oops with 2.6.31 won't fit the screen - how to debug?
References: <200909192155.01225.linux@rainbow-software.org> <200909192344.55258.elendil@planet.nl>
In-Reply-To: <200909192344.55258.elendil@planet.nl>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2009 11:44 PM, Frans Pop wrote:
> Ondrej Zary wrote:
>> hibernation worked great with 2.6.30 - I had over a month of uptime (it
>> never worked so well before - always crashed after some time). But in
>> 2.6.31, it's broken again - and completely. The first hibernation works
>> but it always crashes on the second one.
>>
>> The problem is that the oops is so long that it does not fit the screen -
>> even 1280x1024 is not enough. Scrolling does not work (as it used to do
>> on 2.4 kernels), netconsole does not catch it. So how can I debug this?
> 
> One way to get at least an indication of what broke the hibernation is to 
> run a bisection to find the change that broke hibernation. That could 
> provide sufficient clues for a next step.

And if it is reproducible with some debugging mode (see
Documentation/power/basic-pm-debugging.txt, section Test modes of
hibernation), you may not need to do a full hibernation/thaw cycle.

Could you attach at least the part of the oops you see?
