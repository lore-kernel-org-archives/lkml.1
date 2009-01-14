Return-Path: <linux-kernel-owner+w=401wt.eu-S1762309AbZANMS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762309AbZANMS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZANMSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:18:35 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:46846 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbZANMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y/7toCgDujZpmFSvcrT5VtbOKHHMP40k7JjqDmlNbOOkuemzOh3WwPrgxdgy8fBfK5
         rIGOu/yPWLNvKhJcHGBXihudLDBoFkMLf0HPAWH0mIK1/rh+wuattCjjXzpVrDXFsmlM
         bPhj8mXElnknewVf/ygRmxFrf5oXehntHhYjs=
Message-ID: <28c262360901140418y242586cekd1c3220c2f4336a3@mail.gmail.com>
Date: Wed, 14 Jan 2009 21:18:32 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: lowmemory android driver not needed?
Cc: "Pavel Machek" <pavel@suse.cz>, "Greg KH" <greg@kroah.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "Brian Swetland" <swetland@google.com>, arve@google.com,
       "San Mehat" <san@android.com>, "Robert Love" <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <20090114104834.18387fca@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090114010223.GA21380@kroah.com>
	 <20090114021801.GA14759@bulgaria.corp.google.com>
	 <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
	 <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz>
	 <20090114104834.18387fca@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last time,  it seems my mail is lost.
My mail is mangled by web mail(gmail) which change my mail's base encoding type.

On Wed, Jan 14, 2009 at 7:48 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > Alan, does this sound like it should remain in the tree?
>>
>> Maybe our oom killer should get a new tunable, telling it how
>> aggressive it should be, instead?
>
> I was thinking that, and it would integrate better with the OLPC work
> (which IMHO is a nicer interface for some stuff)
>
> You'd want two thresholds
>
> The 'arghhhh....' point where you start killing stuff
> The 'uh oh...' point where an OLPC style low memory notifier kicks in
>
> (OLPC's model is a handle you can select/poll for 'memory getting low' so
> apps can respond to pressure by doing stuff like dumping caches)

I guess OLPC model is similar to mem_notify.
Last year, Kosaki-san made mem_notify patch series.
It may help this situation.

http://lwn.net/Articles/268732/


> The rest ought to follow naturally IFF you can find a clean efficient way
> to measure that pressure and quantify it as a number. Our default would
> be like now, the Android default might be to trigger earlier..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
