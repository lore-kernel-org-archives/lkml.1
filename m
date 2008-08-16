Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYHPUse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYHPUse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbYHPUky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:40:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54214 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbYHPUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QvPMFUbQzstgKnbwniRBYOPZTdGZq+HMnQuZuiU0yWoE7wsjC1Len8KusQ3qKtATBA
         81cm0BCdMAZWzCnLX+3yLvmj7SoEq5+Wsr36BXPK4pV8UAVcLpboEWGdiiUklAiWRwYX
         sWgkUFnxYpeK3A4jNDZwBfKcdVGxlGCNcwpbo=
Message-ID: <b3ece790808161340x4b03b91er6f0bfcc46c6fb3ad@mail.gmail.com>
Date: Sat, 16 Aug 2008 13:40:50 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: schwidefsky@de.ibm.com
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org,
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
In-Reply-To: <1218908985.6037.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <200808131433.02966.rusty@rustcorp.com.au>
	 <1218733623.2651.14.camel@localhost>
	 <200808150922.23277.rusty@rustcorp.com.au>
	 <1218908985.6037.12.camel@localhost>
X-Google-Sender-Auth: 2dd910a81aa04bca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 10:49 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:

>> > > Can you hash the format string to generate the id?  6 hex digits should
>> > > be enough, and your tool can check for clashes.  As it's bad form to have
>> > > identical strings for different semantics anyway, this seems to make
>> > > sense.

> Ok, so  a specialized version of printk will do the work to calculate
> the hash. Only, what will we do if there ever is a conflict? The message
> tag has to be unique. The shorter the hash is, the more likely a
> collision gets. Don't know if 6 hash digits is enough to just ignore the
> problem.

And if you ever need to change the text that is in the format string?
The hash changes.  That seems exactly counter to your goal...

Tim
