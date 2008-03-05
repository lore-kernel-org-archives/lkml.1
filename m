Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbYCERhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbYCERhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYCERhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:37:40 -0500
Received: from gw.goop.org ([64.81.55.164]:40065 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbYCERhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:37:39 -0500
Message-ID: <47CED91F.4020106@goop.org>
Date: Wed, 05 Mar 2008 09:32:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
References: <a2itf-5jB-27@gated-at.bofh.it>	<493b45a1-bb40-4e3c-9a8e-4b6ee7b8fdc3@b1g2000hsg.googlegroups.com> <20080301132924.0dc22b36@mjolnir.drzeus.cx>
In-Reply-To: <20080301132924.0dc22b36@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Fri, 29 Feb 2008 13:09:05 -0800 (PST)
> Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> Pierre Ossman wrote:
>>     
>>> Many devices today are of a less than stellar quality, and singing
>>> transistors are a common problem. A high-pitch noise is created, caused
>>> by power fluctuations as the processor enters and leaves deep sleep at
>>> a high frequency.
>>>       
>> Capacitors or transistors?  The subject and the description disagree.
>>
>>     
>
> That should teach me to write commit messages when I'm tired... Capacitors is of course the right answer. :)

More likely inductors, I think.  The coils can vibrate against the coil 
if they haven't been properly potted in something.  Capacitors don't 
really have anything which can "sing".

    J
