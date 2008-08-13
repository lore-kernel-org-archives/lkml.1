Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYHMHE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYHMHE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYHMHEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:04:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:13030 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbYHMHEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iinfrK/TFgTTTr75tW8LAkH9+V7kORoXjEgYyCYiqt9ds5+Vy/Wsc7llPeZV7CuA0j
         /KzADfXOe1q3AOlr4VVVX1y/q9qg7XzvBMKP3r1I3zGYWCvogweGkTHJPEKZHTjGkQdx
         eEi1olA7vhqjy5qEO5kPxvT4nLKYIqs240oPs=
Message-ID: <b3ece790808130004p4763b11fveaf4c8380c7c86f7@mail.gmail.com>
Date: Wed, 13 Aug 2008 00:04:11 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Gerrit Huizenga" <gh@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Jan Kara" <jack@suse.cz>,
       "Pavel Machek" <pavel@ucw.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Joe Perches" <joe@perches.com>,
       "=?UTF-8?Q?Jochen_Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <200808131433.02966.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171156.824640459@de.ibm.com>
	 <200808131433.02966.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 90033b0d6c961018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But there are a number of places that have different strings for the
same meaning: "Can't" vs "can't" vs "can not" vs "failed to", etc.

This is a big part of what hurts us - you end up with lots of loose
regexes when parsing logs.

Tim



On Tue, Aug 12, 2008 at 9:33 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thursday 31 July 2008 02:56:57 Martin Schwidefsky wrote:
>> From: Michael Holzheu <holzheu@de.ibm.com>
>> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>>
>> Introduce a new family of printk macros which prefixes each kmsg message
>> with a component name and allows to tag the printk with a message id.
>
> Can you hash the format string to generate the id?  6 hex digits should be
> enough, and your tool can check for clashes.  As it's bad form to have
> identical strings for different semantics anyway, this seems to make sense.
>
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
