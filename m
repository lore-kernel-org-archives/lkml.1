Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYJKLmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYJKLmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 07:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYJKLl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 07:41:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:32559 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYJKLl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 07:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=n4e2KTBt/qAzTkRR7cP5ZtOkpO2GzjB45FjDTkUasHMCtP7HHEROmMijPZ5hl1699K
         uKLj+dzLVYomSLeHhg7/2hgpYFTG9XdQ13yB6kYuGYc/jv32rKQ3xYw8ElNf89lpWV4M
         x9uObvP5HBfDTo4xouWlKhLwMGf+vy9NPbPVo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 0/7] ide: locking improvements
Date: Sat, 11 Oct 2008 13:39:44 +0200
User-Agent: KMail/1.9.10
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <fa.8TkQ+xA96EhlNKL9gIbVTxVrcUE@ifi.uio.no> <48F010AB.7010009@shaw.ca>
In-Reply-To: <48F010AB.7010009@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810111339.44998.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2008, Robert Hancock wrote:
> Bartlomiej Zolnierkiewicz wrote:
> >> Sorry, but I just have to ask 'why'? IDE is seeing a whole lot of churn
> >> for something that should essentially be a stable code base in
> >> maintenance mode, and now scalability improvements?
> > 
> > It is the stable code but being in "maintenance only mode" has never
> > been true and as long as there are active users & developers there is
> > really no reason to change it.
> 
> Are there really many active users at this point? I'm not aware of any 
> new distributions that are using it. The only people I can see that 
> might still want to be using it would be people with old setups or old 
> embedded devices.. many of those wouldn't be using newer kernels anyway.

Like I said before: as long as there are any active users/developers
there is no real reason to stop IDE improvements (especially since there
is no complete replacement available).

I also wouldn't worry that much about what some distros are doing.  They
are free to make their own decisions based on whatever criteria they like.

> These kinds of changes only will really help scalability on multi-core 
> machines which are unlikely to be using this code anyway.. They seem 

>From my perspective the main gain of these patches is the increased
maintainability and sanity of the code, scalability improvements are
just an added bonus.

> rather like putting makeup on a corpse to me..

Please refrain from such comments.  Not only the metaphor is completely
bogus but it may sound disrespectful to some IDE developers.

Thanks,
Bart
