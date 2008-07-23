Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYGWIV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYGWIV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYGWIVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:21:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49898 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYGWIVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:21:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WAYCEsB7lVJLM9RXJQkubb8tdPJA7FJpw8C6IqUHTqmAzamvecTgP8jJX3FDoAPfrQ
         y1/kmmHVRPpNYPjw0IkE5vxvLFZPbUvMjqSlgxQL+MTN8m9me0XuPO5j1wc6apnLs5Po
         h4whE/kI0ug8oIh645JxfekXHThFu8cIfd7eQ=
Message-ID: <86802c440807230121o584d2573g8ec4d4fde857aa3b@mail.gmail.com>
Date: Wed, 23 Jul 2008 01:21:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: 128 GiB memory question-- kernel only sees 64GiB?
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Alan Piszcz" <ap@solarrain.com>
In-Reply-To: <alpine.DEB.1.10.0807221654480.11681@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0807221019570.8455@p34.internal.lan>
	 <1216736883.7257.102.camel@twins>
	 <alpine.DEB.1.10.0807221654480.11681@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 1:55 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Tue, 22 Jul 2008, Peter Zijlstra wrote:
>
>> On Tue, 2008-07-22 at 10:21 -0400, Justin Piszcz wrote:
>>>
>>> Hello,
>>>
>>> To be able to utilize 128 GiB of memory on a host, does one need to
>>> enable
>>> NUMA support? Currently only 64 GiB is showing up.
>>>
>>> As far as machine name/motherboard type, I do not have this information
>>> currently but I am told there are one or two of these boxes are running
>>> CentOS 5.x and/or RHEL5/AS.
>>
>> Sounds like you need to bug RH with that ;-)
>>
>>> Is there something special you need to do to utilize all 128 GiB of
>>> memory?
>>
>> Does a recent kernel work for you? Also, you could at the very least
>> have mentioned your machine architecture; is it x86_64, ia64 or ppc64?
>>
>
> Sun X4600, will find out if they are running the right kernel and also check
> the BIOS, thanks.

so you are using 32 bit kernel?

uname -a

could tell arch

YH
