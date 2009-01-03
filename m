Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZACDkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZACDkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZACDj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:39:56 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:38518 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809AbZACDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:39:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qFODmHwHxudssFVichWd7WNk0DbHOTXoNSISjkgcv9cjsJMoOuzTgW9m+MovS2gGa4
         lrJjiICYGgm6YZ8ndHdlueIulOwube53KqbZafX3CKxkwbaq9zpAeF0AyhcNcGf9pvI4
         C1ExLi/Wx0mOhXWwqs5WUb9s4LhedKeL4r+S4=
Message-ID: <495EDE04.5080703@gmail.com>
Date: Fri, 02 Jan 2009 19:39:48 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: tux3@tux3.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <200901021719.26680.phillips@phunq.net> <495EC040.2070905@gmail.com> <200901021903.24189.phillips@phunq.net>
In-Reply-To: <200901021903.24189.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Friday 02 January 2009 17:32, Justin P. Mattock wrote:
>   
>> Daniel Phillips wrote:
>>     
>>> On Friday 02 January 2009 15:11, Justin P. Mattock wrote:
>>>   
>>>       
>>>> The game that came to mind when I first
>>>> heard of tux3(I had to google a bit to find the name)
>>>> was tux racer.  :^)
>>>> quick question:
>>>> what is the state for security file labeling for
>>>> SELinux on this filesystem?
>>>>         
>>> There is a lot of interest in security labels.  You are not the first
>>> to ask.
>>>
>>> Tux3 variable inode attributes are ideal for implementing security 
>>> labels efficiently, way more lightweight than extended attributes.  
>>> Otherwise, we would like to know exactly what people want.
>>>
>>> Regards,
>>>
>>> Daniel
>>>   
>>>       
>> thats probably one of the main areas of
>> interest that I have in filesystems,
>> the ability to run a policy etc..
>> As for what people want, thats tough
>> to say, my guess would be file corruption,
>> then probably security etc..
>>     
>
> I meant, what do people specifically want in security.  For SELinux,
> probably the most important issue is efficient extended attribute
> support, which Tux3 has a pretty good start on:
>
>    http://lwn.net/Articles/300416/
>    Tux3 gets a high speed atom smasher
>
>   
Thats some crazy stuff!! and just think most of it is
simply magnets.(but more complicated than that)
> One feature we are kicking around to make life easier for SELinux:
> sometimes the filesystem can run while SELinux is not running, and
> security labels will be wrong when SELinux re-enters the picture.  We
> have in mind to provide a persistent log of filesystem events that the
> security system can attach to on startup and find out what went on in
> its absence.
>
>   
That sounds nice:

find out what went on in
its absence.

> And it might be nice to provide direct access to Tux3's variable inode
> attributes as I mentioned, letting the security system bypass the
> heavyweight xattr paths.  My thinking is, the more direct the security
> path, the more likely it is to be secure, and the less overhead it has,
> the more likely people are to use it.  Somebody might want to play with
> this idea and see if it makes a difference.
That makes sense:

the more direct the security
path, the more likely it is to be secure, and the less overhead it has,

> Of course, these features are secondary to base filesystem solidity,
> which will be the main focus for the next little while, but now is the
> time to talk about what you want, in case the design can be adjusted to
> make it more practical.
>
> More security wishes go here: ->[___________________]<-
>
> Regards,
>
> Daniel
>
>   

I guess the most simplest wish would to make sure that tux3
does support SELinux, this way people have more options,
to work with.(Then worry about everything else later);
 One of the main problems I have with osx and winxp
is the missing of such options(I feel naked without SELinux);

regards;

Justin P. Mattock
