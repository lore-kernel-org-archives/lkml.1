Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZDWXYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZDWXYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZDWXXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:23:53 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48040 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZDWXXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=cSn2DqpqzjXqrxGn9zsTorPjOjaFQ0A1R2WZKTZs8naTodW9SXaDy4IAJZaHAwWwAv
         3WpnYSl6oudcdnvekKZa5c0R7TNE9WoLvVOxNZZ+9w31UWUIidQ9dLExLwiSSeYBdJX8
         V6Az2kYo8W5UUMJ0QpQEASlPMgkApmhE7aoTs=
Message-ID: <49F0F876.7090402@gmail.com>
Date: Fri, 24 Apr 2009 01:23:34 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #13067] iwl3945: wlan0: beacon loss from AP - sending probe
 request
References: <crKhD-25m-3@gated-at.bofh.it> <crKhG-25m-5@gated-at.bofh.it> <crN5T-6s8-5@gated-at.bofh.it> <cs3u2-7kZ-13@gated-at.bofh.it> <49EBAA65.80701@gmail.com>
In-Reply-To: <49EBAA65.80701@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2009 12:49 AM, Niel Lambrechts wrote:
> On 04/17/2009 11:10 PM, Rafael J. Wysocki wrote:
>   
>> On Friday 17 April 2009, Justin Madru wrote:
>>     
>>> Rafael J. Wysocki wrote:
>>>       
>>>> This message has been generated automatically as a part of a report
>>>> of recent regressions.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.29.  Please verify if it still should be listed and let me know
>>>> (either way).
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13067
>>>> Subject		: iwl3945: wlan0: beacon loss from AP - sending probe request
>>>> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
>>>> Date		: 2009-04-05 9:11 (12 days old)
>>>> References	: http://marc.info/?l=linux-kernel&m=123892272218266&w=4
>>>>
>>>>
>>>>   
>>>>         
>>> I'm getting this on .30rc2, so I confirm that it's still an issue (I'm 
>>> not the original submitter).
>>> It's really annoying because it's filling my logs like crazy. Below is 
>>>       
>
> Quite similar here, same kernel. I don't get this on 2.6.29 or 2.6.28:
>   
Just to let you know, this is still present in 2.6.30-rc3:

Apr 24 01:19:20 linux-7vph kernel: wlan0: beacon loss from AP
00:1d:92:1d:1e:8e - sending probe request
Apr 24 01:19:58 linux-7vph kernel: wlan0: beacon loss from AP
00:1d:92:1d:1e:8e - sending probe request
Apr 24 01:20:57 linux-7vph kernel: wlan0: beacon loss from AP
00:1d:92:1d:1e:8e - sending probe request
Apr 24 01:22:19 linux-7vph kernel: wlan0: beacon loss from AP
00:1d:92:1d:1e:8e - sending probe request

Niel

