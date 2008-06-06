Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbYFFOvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbYFFOvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbYFFOvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:51:37 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:48266 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbYFFOvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:51:36 -0400
Message-ID: <48494EF6.4020506@mandriva.org>
Date: Fri, 06 Jun 2008 17:51:34 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Thomas Backlund <tmb@mandriva.org>, Ian Schram <ischram@telenet.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org>	 <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com>	 <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org>	 <48485F12.2050908@mandriva.org> <48488878.5040708@telenet.be>	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org> <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
In-Reply-To: <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Winkler skrev:
> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>> Thomas Backlund skrev:
>>> Tomas Winkler skrev:
>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be> wrote:
>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>>>
>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>>>
>>>>> invalid length of webkey that would/should be handled in mac80211?
>>>>>
>>>>> ian
>>>> Yes, it looks like.
>>> Ummm, what has a wep key to do with me trying to access a WPA2-Personal
>>> encrypted net ?
> 
> Not sure yet, but mac is trying to assign default/static wep key.
> 
> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
> 
> Try to set the encryption explicitly
> network={
>     psk="*************************"
>     scan_ssid=1
>     ssid="dlink"
>     pairwise=CCMP
>    group=CCMP
>  }
> 
> 

That didn't help at all...

What's more it prevented the wifi to work on 2.6.24.7 so I had to remove 
the lines again...

--
Thomas
