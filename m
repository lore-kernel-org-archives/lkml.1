Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0CDISu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:18:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:26802 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab0CDISt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qV7ZH6PLMJfbNAAAlubVUMz8Q+4YnwIAC3B6WiWzyGOECaCWVLxKUyCBntCeETEf8D
         9H754KSAAhDsJowFhdzRkwNlXVriFOV9z/FZy1z5hl3EDqnPLOItqA0qUEXDmnj8Rvj2
         X4xrHBf+49p8WSfcagC+LDPXB02dvFNep1XCc=
MIME-Version: 1.0
In-Reply-To: <1267690494.6355.2.camel@marge.simson.net>
References: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com>
	 <1267673633.6416.7.camel@marge.simson.net>
	 <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
	 <1267688823.7029.8.camel@marge.simson.net>
	 <40a4ed591003032355t46e356f8qadfded7450934b51@mail.gmail.com>
	 <1267689791.10101.4.camel@marge.simson.net>
	 <1267690494.6355.2.camel@marge.simson.net>
Date: Thu, 4 Mar 2010 09:18:48 +0100
Message-ID: <40a4ed591003040018m609c039fx4c35aa3c98614dfa@mail.gmail.com>
Subject: Re: evdev keyboard driver stopped working after upgrading from Kernel 
	2.6.33-rc8 to 2.6.33 (official release)
From: Zeno Davatz <zdavatz@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 9:14 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2010-03-04 at 09:03 +0100, Mike Galbraith wrote:
>> On Thu, 2010-03-04 at 08:55 +0100, Zeno Davatz wrote:
>>
>> > Ok, I will try that. Can you give a short input of how I should start bisecting?
>>
>> git bisect start
>> git bisect good v2.6.33-rc8
>> git bisect bad v2.6.33
>>
>> build and test each iteration, should be quick/painless if it's rc8.
>
> Um, with git bisect good/bad after each test to tell git which direction
> to go.  You might need to know that, since you've never done a bisection
> before ;-)

Thanks! I will try asap. First I gonna upgrade Git to 1.7.0

Best
Zeno
