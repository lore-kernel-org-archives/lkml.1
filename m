Return-Path: <linux-kernel-owner+w=401wt.eu-S2993316AbXEBPKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993316AbXEBPKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993318AbXEBPKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:10:37 -0400
Received: from mail.tmr.com ([64.65.253.246]:51667 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993316AbXEBPKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:10:36 -0400
Message-ID: <4638AA2E.4090504@tmr.com>
Date: Wed, 02 May 2007 11:11:42 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] 2.6.21 vs. 2.6.21-sd046 vs. 2.6.21-CFSv7
References: <463643A9.5040009@tmr.com> <46364A75.9080003@tmr.com> <20070430201659.GA5681@gnuppy.monkey.org>
In-Reply-To: <20070430201659.GA5681@gnuppy.monkey.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
> On Mon, Apr 30, 2007 at 03:58:45PM -0400, Bill Davidsen wrote:
>   
>> Followup: I reran with sd-0.46, setting rr_interval to 40, and then 5 
>> (default was 16). Neither appeared to give a useful video playback. I 
>> did try setting the make to nice 10, and that made the playback 
>> perfectly smooth, as well as response to skip forward and volume change 
>> happening when the key was pressed instead of eventually.
>>
>> I also tried raising the nice of X to -10, that made things better on 
>> display, but I winder if it will let X run ahead of the nice-0 raid threads.
>>
>> Is this my hardware or is there a really odd behavior here? The sd seems 
>> to be too fair to cope well with this realistic load, and expecting 
>> users to nice things is probably morally correct but unrealistic.
>>     
>
> People have been reporting very good performance with regards to OpenGL
> applications under SD. What is your video driver ? NVidia proprietary ?
>
>   
My original post I was following gave my config, built-in graphics using 
945G framebuffer. This is a server, I'm not a gamer. The only fancy 
graphics I have are on a system with no on board video at all, I picked 
up a moderately high-end Radeon card to drop in. And to give you an idea 
of what a gamer I am, that uses the vesafb driver ;-)
> OpenGL, X and direct frame buffer access (mplayer and friends) tend not
> to interact each other which can result in very different scheduling
> characteristics between them.
>   

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

