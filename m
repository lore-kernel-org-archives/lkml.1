Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYHMOul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYHMOul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYHMOuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:50:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45267 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYHMOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NDuIaXffa4/SOALUXn7kY6gxDY4pLGcgkfrIhUMLwuWtI9OmA+pRfz6BQJGvIkm/jT
         2aR85XIj8ADX31Vlzl+ZHgV1NICNnIIBZJXvvYHuW/OtdgjUgl6BvJAO/QdYWtb3xjtj
         cXf8KJuC1yDauqUk40HSKczdX5C5DpoYX7ay0=
Message-ID: <b3ece790808130750x37e44e48u125a95780ff32d8a@mail.gmail.com>
Date: Wed, 13 Aug 2008 07:50:14 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Gerrit Huizenga" <gh@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Jan Kara" <jack@suse.cz>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Joe Perches" <joe@perches.com>,
       "=?UTF-8?Q?Jochen_Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <20080813071323.GA6298@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171156.824640459@de.ibm.com>
	 <200808131433.02966.rusty@rustcorp.com.au>
	 <b3ece790808130004p4763b11fveaf4c8380c7c86f7@mail.gmail.com>
	 <20080813071323.GA6298@elf.ucw.cz>
X-Google-Sender-Auth: 97c01f2b522af408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 12:13 AM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> But there are a number of places that have different strings for the
>> same meaning: "Can't" vs "can't" vs "can not" vs "failed to", etc.
>
> Do you have examples?
>
> That wastes space in bzImage (and hints of duplicated code), so we may
> want to fix it anyway.

I can look for the specific examples.  I just saw the regexes we use
this week and was taken aback at how they have been loosened for these
sorts of cases.
