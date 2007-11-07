Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbXKGF7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbXKGF7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXKGF7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:59:01 -0500
Received: from gw.goop.org ([64.81.55.164]:40961 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbXKGF7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:59:00 -0500
Message-ID: <47315421.7080706@goop.org>
Date: Tue, 06 Nov 2007 21:58:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       hollisb@us.ibm.com
Subject: Re: [kvm-devel] include files for kvmclock
References: <11943875362987-git-send-email-gcosta@redhat.com>	<11943875433821-git-send-email-gcosta@redhat.com> <5d6222a80711061335q7ef03b42i335bb1e8c07eb7e4@mail.gmail.com> <4731535E.5000808@qumranet.com>
In-Reply-To: <4731535E.5000808@qumranet.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Glauber de Oliveira Costa wrote:
>   
>>> +union kvm_hv_clock {
>>> +       struct {
>>> +               u64 tsc_mult;
>>> +               u64 now_ns;
>>> +               /* That's the wall clock, not the water closet */
>>> +               u64 wc_sec;
>>> +               u64 wc_nsec;
>>>     
>>>       
>
> Do we really need 128-bit time?  you must be planning to live forever.
>   

Well, he's planning on having lots of very small nanoseconds.

    J
