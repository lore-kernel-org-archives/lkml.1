Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbYFFPNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbYFFPNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYFFPM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:12:56 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:25408 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbYFFPMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dasstt+CSbnY59Jn8dBsLqKigDtjPJm38yNTln7dvgRQqocTZzB3MhHKqTzJhYZLIP
         /04xXmwT8caXK9sO2ODPr7bM3sRpeW93WZYxe8npQN6CfxF8WI7kiUBRuznES2nB/m1E
         /dY0uNtT2ukDcaxh2F4k+FshNREi/yxRcKZUk=
Message-ID: <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>
Date: Fri, 6 Jun 2008 18:12:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Thomas Backlund" <tmb@mandriva.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
Cc: "Ian Schram" <ischram@telenet.be>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <48494EF6.4020506@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4848289D.1080205@mandriva.org> <48482BC3.4070402@mandriva.org>
	 <4848482C.2080208@mandriva.org> <48485F12.2050908@mandriva.org>
	 <48488878.5040708@telenet.be>
	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>
	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>
	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
	 <48494EF6.4020506@mandriva.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 5:51 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> Tomas Winkler skrev:
>>
>> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>>>
>>> Thomas Backlund skrev:
>>>>
>>>> Tomas Winkler skrev:
>>>>>
>>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be> wrote:
>>>>>>
>>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>>>>
>>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>>>>
>>>>>> invalid length of webkey that would/should be handled in mac80211?
>>>>>>
>>>>>> ian
>>>>>
>>>>> Yes, it looks like.
>>>>
>>>> Ummm, what has a wep key to do with me trying to access a WPA2-Personal
>>>> encrypted net ?
>>
>> Not sure yet, but mac is trying to assign default/static wep key.
>>
>> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
>> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
>>
>> Try to set the encryption explicitly
>> network={
>>    psk="*************************"
>>    scan_ssid=1
>>    ssid="dlink"
>>    pairwise=CCMP
>>   group=CCMP
>>  }
>>
>>
>
> That didn't help at all...
>
> What's more it prevented the wifi to work on 2.6.24.7 so I had to remove the
> lines again...
>
So what's your AP configuration TKIP?

Second try also with sw decryption:

in /etc/modprobe.conf
options iwl4965 swcrypto=1


Tomas
