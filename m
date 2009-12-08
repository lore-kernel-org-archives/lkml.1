Return-Path: <linux-kernel-owner+w=401wt.eu-S966907AbZLHXCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966907AbZLHXCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966533AbZLHXCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:02:19 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:63677 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966574AbZLHXCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qMZAPwDmeFQ8onFz6lwQp+3pi0q6f048/ihVWElWXGzs/3hJVBUbebSvLLyVzdvW+Q
         /4sEp/p/dp9k24BjVOBZbKWkEyot4B5UtFLcYRPBBCFHJs7Ta80+BRtudfWCOUBBceZi
         9hPyxq6C6cKhFLzdnVFz7j2SkJ+sQopiz7EI0=
MIME-Version: 1.0
In-Reply-To: <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
References: <20091208214246.GA21857@kroah.com>
	 <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
Date: Tue, 8 Dec 2009 18:02:23 -0500
X-Google-Sender-Auth: 6d40b237724f2abf
Message-ID: <37219a840912081502v3fdf1879xdb28e867eb82884c@mail.gmail.com>
Subject: Re: 2.6.27.40 build error
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 4:49 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, Dec 8, 2009 at 4:42 PM, Greg KH <greg@kroah.com> wrote:
>> It turns out that the patch below causes a build failure on the
>> 2.6.27.40 kernel.
>>
>> Michael, should I just drop it, or should I take out the line with the
>> "capture_transfer_done" in it, as that member is not in the structure in
>> this kernel version.
>>
>> thanks,
>>
>> greg k-h
>
> There were several different leaks and crash conditions addressed
> since 2.6.27, and it is entirely possible that just removing the line
> is not the correct course of action.
>
> I would propose just dropping the patch for 2.6.27, as we would have
> to rework it taking into consideration the other fixes which were done
> since then.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

Greg,

Yes -- please drop it for now.  I didn't actually send this for
2.6.27.y anyway -- it must have gotten to you some other way.

Devin, if 2.6.27.y needs this fix, can you please generate the
appropriate backport and test it before we resubmit?

Cheers,

Mike Krufky
