Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbXKGMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbXKGMtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 07:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXKGMtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 07:49:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXKGMtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:49:08 -0500
Message-ID: <4731B45F.20300@redhat.com>
Date: Wed, 07 Nov 2007 10:49:35 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       hollisb@us.ibm.com
Subject: Re: [kvm-devel] include files for kvmclock
References: <11943875362987-git-send-email-gcosta@redhat.com>	<11943875433821-git-send-email-gcosta@redhat.com> <5d6222a80711061335q7ef03b42i335bb1e8c07eb7e4@mail.gmail.com> <4731535E.5000808@qumranet.com> <47315421.7080706@goop.org>
In-Reply-To: <47315421.7080706@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeremy Fitzhardinge escreveu:
> Avi Kivity wrote:
>> Glauber de Oliveira Costa wrote:
>>   
>>>> +union kvm_hv_clock {
>>>> +       struct {
>>>> +               u64 tsc_mult;
>>>> +               u64 now_ns;
>>>> +               /* That's the wall clock, not the water closet */
>>>> +               u64 wc_sec;
>>>> +               u64 wc_nsec;
>>>>     
>>>>       
>> Do we really need 128-bit time?  you must be planning to live forever.
>>   
> 
> Well, he's planning on having lots of very small nanoseconds.
> 
>     J
The wc_nsec is legacy, and should be gone. It's not really used in
current code. However, you gave me a very good idea. Living forever
would be awesome! Where can I apply ?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHMbRfjYI8LaFUWXMRAjsQAJ4vDBW0M48fMaL9sl6XfN0+Pd82egCgutwe
9rR7+H8MUQznyinlJc76kbo=
=b3wx
-----END PGP SIGNATURE-----
