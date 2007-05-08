Return-Path: <linux-kernel-owner+w=401wt.eu-S1031373AbXEHTP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031373AbXEHTP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031324AbXEHTPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:15:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51584 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031241AbXEHTPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rClUuW7/P8e8xuFGplWgFXoSv1hrhqv//EcfAHIQ4gHHm7qmQR4BN5BEwv0TJEQTdaJGJt6URK6mP/zvvEhc9n3rq8wC6Z+woqSBQa8Gtf1pdODcDHNCxs0t4ZwzW6qsZCJ/bavFtfePvHptunypLbqH45ne7ZklAmXCeZL7J9Q=
Message-ID: <84144f020705081215t73f2c0fq8ecb677423329cd8@mail.gmail.com>
Date: Tue, 8 May 2007 22:15:18 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>
Subject: Re: [PATCH 1/2] LogFS proper
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       "David Chinner" <dgc@sgi.com>
In-Reply-To: <20070508163226.GA22443@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070507215913.GA15054@lazybastard.org>
	 <20070507220036.GB15054@lazybastard.org>
	 <1178608950.3042.273.camel@localhost.localdomain>
	 <20070508163226.GA22443@lazybastard.org>
X-Google-Sender-Auth: d5b4b1d35591e494
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Jörn Engel <joern@lazybastard.org> wrote:
> > > +typedef __be16 be16;
> > > +typedef __be32 be32;
> > > +typedef __be64 be64;
> >
> > Why are those typedefs necessary ?
>
> Not strictly.  I tend to use the be* types fairly often in the code and
> simply grew weary of seeing the underscores.
>
> Any objections if I seperate out the userspace headers and keep the
> shorthands for kernel code only?

Not sure what you mean but I would prefer you drop the typedefs completely.
