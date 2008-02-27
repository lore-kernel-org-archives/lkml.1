Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbYB0AOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbYB0AOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbYB0AO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:14:27 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:8276 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbYB0AO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=YEVYzN8vW9OOSHZfXiMUUpPCpS9zyr+XsFPLcbfiStuEyfuXrP/Fs45eUAnKKrM6aWP4sZlEWBjTE1ZJkD0IX+fH/8ZTPe56uv1eywz0PRR5wHbRulSWRvXjCP4shCY8M5SUm500UJFnHLAmQJtItDVgTTsvT2oc5FLzfqiTtXI=
Message-ID: <47C4AB5D.3000900@panasas.com>
Date: Tue, 26 Feb 2008 16:14:21 -0800
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>,
       Randy Dunlap <randy.dunlap@oracle.com>
CC: khc@pm.waw.pl, bhalevy.lists@gmail.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] CodeStyle: Use spaces when aligning/decorating
References: <1204062430.47c488def40a4@portal.student.luth.se> <20080226135444.f83a0536.randy.dunlap@oracle.com> <47C48FD8.5040205@student.ltu.se>
In-Reply-To: <47C48FD8.5040205@student.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 26, 2008, 14:16 -0800, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Randy Dunlap wrote:
>> On Tue, 26 Feb 2008 22:47:10 +0100 ricknu-0@student.ltu.se wrote:
>>
>>   
>>> Relaxing the 'tab = 8 character', which leads to 'don't tab the alignment'.
>>> By only using tabs for indentation, we solidify it as a 'logical indentation'.
>>>
>>> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
>>> ---
>>> To'ed the people who showed interest in the (apparently not so new)
>>> question/suggestion of not using tabs when aligning.
>>> If this looks ok, then checkpatch.pl is next...
>>>
>>>
>>> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>>> index 6caa146..1b3f448 100644
>>> --- a/Documentation/CodingStyle
>>> +++ b/Documentation/CodingStyle
>>> @@ -15,10 +15,8 @@ Anyway, here goes:
>>>  
>>>  	 	Chapter 1: Indentation
>>>  
>>> -Tabs are 8 characters, and thus indentations are also 8 characters.
>>> -There are heretic movements that try to make indentations 4 (or even 2!)
>>> -characters deep, and that is akin to trying to define the value of PI to
>>> -be 3.
>>> +This project is recommended to be viewed with a tab-width of 8 characters
>>> +(and other code).
>>>     
>> FWIW I prefer the {deleted} language.  // PI = 3;
>>   
> Well, actually I like it too. But I think it should be up to the 
> programmer which setting to use + it seems some people have really taken 
> this to heart, going from 'tab => 8 characters wide' to '8 spaces => 
> tab', obscuring tab's position as a 'logical indention'.
> 
> Richard Knutsson
> 

How about this:

-Tabs are 8 characters, and thus indentations are also 8 characters.
-There are heretic movements that try to make indentations 4 (or even 2!)
-characters deep, and that is akin to trying to define the value of PI to
-be 3.
+Tabs are used for logical indentation, e.g., code is indented with
+a number of tabs equal to its nesting level.  From there on,
+use space characters for decorative indentation.  This method
+is agnostic to the editor's tab-expansion settings.
+That said, expanding tabs to a small number of spaces (4, or even 2!) encourages
+excessive nesting and resulting over-complexity; that is akin to trying to define
+the value of PI to be 3.  Therefore, tabs are always assumed to be 8 characters-wide.

