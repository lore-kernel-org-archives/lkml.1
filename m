Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYEPP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYEPP5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYEPP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:57:19 -0400
Received: from mail11e.verio-web.com ([204.202.242.84]:1959 "HELO
	mail11e.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751873AbYEPP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:57:18 -0400
Message-ID: <482DAEDB.70702@sensoray.com>
Date: Fri, 16 May 2008 08:57:15 -0700
From: dean <dean@sensoray.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <greg@kroah.com>,
       v4l-dvb-maintainer@linuxtv.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
References: <20080514205927.GA13134@kroah.com> <20080515235102.756407d3@gaivota> <200805160828.13856.oliver@neukum.org>
In-Reply-To: <200805160828.13856.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: [F=0.0100000000; S=0.010(2008040101); MH=0.500(2008040918)]
X-MAIL-FROM: <dean@sensoray.com>
X-SOURCE-IP: [161.58.148.42]
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Just to be clear.  You mean fixing the loading issues(ugly msleep, 
etc...) that Mauro mentioned, not the YUV formats(which seem unrelated)? 

Would it be ok to have just 422P and greyscale in the driver for now if 
we can't get a firmware update in a reasonable timeframe? It's certainly 
not ideal, but we could direct our customers to the libraries, at least 
until we get a proper HW fix.

Best regards,

Dean


Oliver Neukum wrote:
> Am Freitag 16 Mai 2008 04:51:02 schrieb Mauro Carvalho Chehab:
>   
>>> +static DEFINE_MUTEX(usb_s2255_open_mutex);
>>>       
>> Hmmm... what happens if the user plugs two or more of such devices?
>>     
>
> Concurrent calls to open() will be delayed. Not a problem, if the
> firmware issue is fixed as it needs to be.
>
> 	Regards
> 		Oliver
>
>
>   

