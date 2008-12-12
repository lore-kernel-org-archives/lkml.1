Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYLLVA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYLLVA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYLLVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:00:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:6187 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYLLVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HZkWyfxmUdSEVhDvSccomPYjDSFmtx7FVDhdOZ0JWhE2KFA58r/oMwFk475gThAUv2
         K2gbffWj8kcQSFpBHpovSdVvyOkWg834KeRNNk98N+7i5fx05xiZcPhPfpjPK1paq/jV
         LjjeTmWTtLCtJqOyAQAwEJrURLmyUOdB30xHk=
Message-ID: <8bd0f97a0812121300p6c509336pde936b7f8c5ca6a@mail.gmail.com>
Date: Fri, 12 Dec 2008 16:00:02 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from platform_driver remove functions
Cc: "Vorobiev Dmitri" <dmitri.vorobiev@movial.fi>,
       "Julia Lawall" <julia@diku.dk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <20081212051759.GA12563@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
	 <8bd0f97a0812100928l2c75d373n7eba5aa0cc3882fd@mail.gmail.com>
	 <53806.88.114.236.15.1228947522.squirrel@webmail.movial.fi>
	 <8bd0f97a0812101437r4abb9346p8bc8d512ddc02cde@mail.gmail.com>
	 <20081212051759.GA12563@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 00:17, Greg KH wrote:
> On Wed, Dec 10, 2008 at 05:37:42PM -0500, Mike Frysinger wrote:
>> On Wed, Dec 10, 2008 at 17:18, Vorobiev Dmitri wrote:
>> >> On Wed, Dec 10, 2008 at 11:26, Julia Lawall wrote:
>> >>  you'll get a
>> >> warning in C about the assignment, but you wont get a build failure,
>> >
>> > ...unless you compile with -Werror, which frequently the case.
>>
>> anyone crazy enough to build with -Werror is crazy enough to send in a fix ;)
>
> Hm, have you noted that some arches have that flag enabled in their
> build?

i dont see anyone building things beyond a select dir or two (none of
which contain platform drivers) with -Werror.  where are you seeing
this ?

besides, while using -Werror in development may make sense, sticking
it into the release for end users is just plain mean.  gcc is so
unreliable with warnings across versions.
-mike
