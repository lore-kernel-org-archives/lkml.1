Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZLOSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZLOSl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZLOSl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:41:27 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:34735 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZLOSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:41:26 -0500
Message-ID: <4B27D756.4050102@gawab.com>
Date: Tue, 15 Dec 2009 10:37:10 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Shredder/3.0
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] staging: s5k3e2fx.c: reduce complexity by factoring
References: <1260065000-5573-1-git-send-email-jdm64@gawab.com> <2c0942db0912142002p638a187araa837812862e5b17@mail.gmail.com>
In-Reply-To: <2c0942db0912142002p638a187araa837812862e5b17@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 08:02 PM, Ray Lee wrote:
> On Sat, Dec 5, 2009 at 6:03 PM, Justin Madru<jdm64@gawab.com>  wrote:
>    
>> I was style fixing some code when I ran into this code.
>> It seems like the code could be reduced, by factoring the expression.
>> But this results in a very simple expression.
>>
>> Am I assuming something wrong? Or is this a bug in the original code?
>> This doesn't look right because the assignment of s_move[i] has no mention
>> of the loop counter.
>>      
> Algebraic factoring is not valid in general when dealing with pure
> integer expressions that may contain rounding issues. I haven't
> checked to see if that's the case with the code you're changing, but
> that sort of expression you're removing is very commonly used exactly
> to deal with rounding issues.
>    

I know that's true and that's why I was questioning if my patch actually 
removed a necessary calculation.
But, wouldn't you agree that if the code was suppose to deal with 
"rounding issues" that there's a
simpler expression?

Justin
