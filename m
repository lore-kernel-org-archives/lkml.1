Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZEKWZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZEKWZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZEKWZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:25:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58945 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbZEKWZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pYy+1DOCRk+0P6uiqXPGOMfqFA4YKkB169SHc/KVWnoNhjvN+WGnhEFYg685J6t3Oj
         vx56rUyfia6eVv0vITa1k8dX+F/hVTP1oQCWLjVq8e1PrvmV6UHWOU7N6tNlW7K79oLa
         wQ0hgjo/BqfIgWkBA9wEyAApV0pXM4+lBOjPk=
MIME-Version: 1.0
In-Reply-To: <4A089E49.7080403@gmail.com>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com> 
	<4A089E49.7080403@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 May 2009 15:24:59 -0700
Message-ID: <43e72e890905111524t27c2659crad86643771d14a31@mail.gmail.com>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 2:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Adding some CCs.
>
> On 05/11/2009 07:02 PM, Justin Mattock wrote:
>> I've been trying to diagnose an issue
>> with 2.6.30-rc4. At first thinking it
>> was not the kernel, but the network manager
>> (in my case I use wicd).
>> with 2.6.29-rc8 the system starts up,
>> connects no problem.
>> but as soon as I load 2.6.30-rc4
>> I get limited connection to none.
>> in dmesg I see:
>>
>> [   36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
>> [   36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
>> [   36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
>> [   36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
>> [   44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
>> [   44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
>> [   44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
>> [   45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
>>
>> The type of encryption used is just
>> a standard WEP key(no WPA).
>>
>> has this been resolved already?

Can you provide more details, like the AP you used, and card you have?
(dmesg log would be nice).

  Luis
