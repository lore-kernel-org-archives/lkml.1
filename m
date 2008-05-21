Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbYEUQDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbYEUQDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 12:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbYEUQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 12:03:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144AbYEUQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 12:03:07 -0400
Message-ID: <483447A2.8060205@zytor.com>
Date: Wed, 21 May 2008 09:02:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Oliver Hartkopp <oliver@hartkopp.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com> <20080521111637.GA5416@ucw.cz>
In-Reply-To: <20080521111637.GA5416@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>
>> Foo-gitX has always been a development snapshot which 
>> *follows* Foo.
> 
> Well, unfortunately its not there in the makefile, so you can't tell
> 2.6.25 from 2.6.26-rc0...
> 
> Would 'rc0' make robots happy?
> 							Pavel
> 

It'll probably make some of them work and break others.  It's pretty 
hard-coded in most of them that the flow is from 2.6.25 -> 
2.6.26-{pre,rc}*; whether or not they permit a zero probably depends on 
if they know what is available or not (ketchup wouldn't be able to, for 
example, but the kernel.org incdiff robot *might* "just work".)

	-hpa
