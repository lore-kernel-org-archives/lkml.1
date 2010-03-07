Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0CGD37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 22:29:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:64457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0CGD34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 22:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mpybSJ08xVdRt7Uh8l/B8I9869/jnZ/A0UOo5xuTfvgy+FrTXHUdCSAv73JSxefN84
         YKur5X9DnZ2lkyQ3n/Bb9y+LFV8FA3QEIsvGqYXGENAIHxhe9TKGsIsoe0ZRdb7SQ26b
         r976nfEUlyA9YMJ1DLcvKetDrsVinVgMQka4c=
MIME-Version: 1.0
In-Reply-To: <OFC651A6C0.BD37C0C8-ON852576DF.0004365B-852576DF.00045289@us.ibm.com>
References: <20100306112125.GN4958@bicker>
	 <ea6602021003061330j56132f8er73e27f017e6b9d09@mail.gmail.com>
	 <OFC651A6C0.BD37C0C8-ON852576DF.0004365B-852576DF.00045289@us.ibm.com>
Date: Sat, 6 Mar 2010 22:29:54 -0500
Message-ID: <ea6602021003061929y6324e019n3b7e941804638342@mail.gmail.com>
Subject: Re: [patch] security: ima_file_mmap() don't just return zero
From: Vikram Dhillon <dhillonv10@gmail.com>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Dan Carpenter <error27@gmail.com>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>,
       James Morris <jmorris@namei.org>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 7:47 PM, Mimi Zohar <zohar@us.ibm.com> wrote:
> Vikram Dhillon <dhillonv10@gmail.com> wrote on 03/06/2010 04:30:33 PM:
>
>> On Sat, Mar 6, 2010 at 6:21 AM, Dan Carpenter <error27@gmail.com> wrote:
>> > It seems like we should return an error here.  That's what the comment
>> > says we should do.
>> >
>> > I also removed an out of date comment.  It wasn't needed and seemed
>> > likely
>> > to get out of date again.
>> >
>> > Signed-off-by: Dan Carpenter <error27@gmail.com>
>> > ---
>
> The current code and comment are correct, as the return code will reflect
> the file's integrity appraisal, which hasn't yet been implemented.
>
> Mimi

Oh right :) I guess we aren't at a point yet to enforce integrity, so
what should the return code return? Based on the comment the code
seemed okay but I think we may have to base it on measurement
appraisal in LIM (then again, not too sure if this is the right
approach).

-- 
Regards,
Vikram Dhillon

~~~
There are lots of Linux users who don't care how the kernel works, but
only want to use it. That is a tribute to how good Linux is.
-- Linus Torvalds
