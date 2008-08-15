Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYHOFdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYHOFdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYHOFdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:33:13 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:6408 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYHOFdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=IPI+zs+Chy5BJkTbJIDXvDj2j6xUBxZF7E2uPCkfU9AnxKe4c+Kih1Dv+kGpJD+6un
         K7o0RkJPo+eFfy2vSeMp91YkPLbnYQ1K+siLgy7Zku9nAb/cTfb/KsSBuFNpesBqBfPK
         ul7ZFDLBKyqXRSJ/kH1lU8HAXlky8iMMBRcoc=
Message-ID: <b3ece790808142233y3150b4d1sfeaa0342dbac31a6@mail.gmail.com>
Date: Thu, 14 Aug 2008 22:33:10 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: "Joe Perches" <joe@perches.com>, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Gerrit Huizenga" <gh@us.ibm.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Jan Kara" <jack@suse.cz>,
       "Pavel Machek" <pavel@ucw.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "=?UTF-8?Q?Jochen_Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <20080815034419.GB803@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171156.824640459@de.ibm.com>
	 <b3ece790808121735t21b4a629iaf6a968b30332d74@mail.gmail.com>
	 <1218733457.2651.11.camel@localhost>
	 <b3ece790808141150s3770531bsc88ec387e0f840d3@mail.gmail.com>
	 <1218769739.24527.76.camel@localhost> <20080815034419.GB803@suse.de>
X-Google-Sender-Auth: 8718f3a80fad7695
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 8:44 PM, Greg KH <gregkh@suse.de> wrote:
>
> What is wrong with what we have already agreed to standardise on here
> people?  dev_printk() for devices!  It uniquely shows the device, what
> driver is bound to it (if any), the bus id, and everything else.

Part of the problem, imho, is the "if any" part.  But I am more than happy to
build on existing solutions.  All the world is not a dev, though.  I'd like to
be able to report something like an OOM kill in (roughly) the same way as an
ATA error, and I want (though could be talked out of) a way to tell these
"events" (for lack of a better word) apart from plain-old-printk()s.

Tim
