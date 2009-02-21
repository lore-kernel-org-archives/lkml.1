Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZBUHuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZBUHuS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZBUHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:50:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:50393 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZBUHuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NfytYju69hfxybBj/00gzGM/CB06bmZkH1Mhabjc3qKC6KZHwYjrUBYz0rLUOnkVSm
         RzMX1aXvQsL5Q56Qt438kQ+gNa7kJOBMKA4ReeYb2lx7ZNboqIbbSmohkcLdBkqzUYxu
         JGI6p+BYZTeB6+wBo1fk939bu8HBgJq+VeUFQ=
MIME-Version: 1.0
In-Reply-To: <20090220225247.GY32564@gandalf>
References: <1235046677-29959-1-git-send-email-me@felipebalbi.com>
	 <20090220141505.d1d53e4b.akpm@linux-foundation.org>
	 <20090220222911.GV32564@gandalf> <20090220225247.GY32564@gandalf>
Date: Sat, 21 Feb 2009 13:20:00 +0530
Message-ID: <5d5443650902202350p206e58ebvcd9becfd04a4133@mail.gmail.com>
Subject: Re: [PATCH] input: keyboard: introduce lm8323 driver
From: Trilok Soni <soni.trilok@gmail.com>
To: me@felipebalbi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       felipe.balbi@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Sat, Feb 21, 2009 at 4:22 AM, Felipe Balbi <me@felipebalbi.com> wrote:
> On Sat, Feb 21, 2009 at 12:29:12AM +0200, Felipe Balbi wrote:
>> On Fri, Feb 20, 2009 at 02:15:05PM -0800, Andrew Morton wrote:
>> > On Thu, 19 Feb 2009 14:31:17 +0200
>> > Felipe Balbi <me@felipebalbi.com> wrote:
>> >
>> > > +struct lm8323_platform_data {
>> > > + int debounce_time; /* Time to watch for key bouncing, in ms. */
>> > > + int active_time; /* Idle time until sleep, in ms. */
>> > > +
>> > > + int size_x;
>> > > + int size_y;
>> > > + int repeat : 1;
>> >
>> > lm8323_platform_data.repeat appears to be never-written-to?
>>
>> Nobody is using that yet, still it's used in the driver:
>>       if (pdata->repeat)
>>               __set_bit(EV_REP, idev->evbit);
>>

Thanks for addressing my review comments to this patch and of course Andrew's.

Happy to add

Reviewed-by: Trilok Soni <soni.trilok@gmail.com>

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
