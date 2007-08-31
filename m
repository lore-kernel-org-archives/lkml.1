Return-Path: <linux-kernel-owner+w=401wt.eu-S966485AbXHaVcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966485AbXHaVcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbXHaVc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:32:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:28301 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965781AbXHaVc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=owzajt00pmexVzkVgy9ZPdC247JwzRaU/33N56/7R+qx2wAWRV1ixDIrmvgWvqQSmRT3WvBvM2vqLQ8We1gCwN4oeD91VdshL90Q/fFWKsQRydE82RZNubuXH2dmAX7lvdC+LD7satBmme0PkVEbjsFJwlR3EoVtoNeXI9nZ65Y=
Message-ID: <9a8748490708311432q4d8e639djbef6640e0ca08e71@mail.gmail.com>
Date: Fri, 31 Aug 2007 23:32:26 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jason Lunz" <lunz@falooley.org>
Subject: Re: jffs2 deadlock introduced in linux 2.6.22.5
Cc: jffs-dev@axis.com, "David Woodhouse" <dwmw2@infradead.org>,
       stable@kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070831212636.GB12868@falooley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070830182354.GA25077@falooley.org>
	 <20070831212636.GB12868@falooley.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/2007, Jason Lunz <lunz@falooley.org> wrote:
> On Thu, Aug 30, 2007 at 11:23:55AM -0700, Jason Lunz wrote:
> > commit 1d8715b388c978b0f1b1bf4812fcee0e73b023d7 was added between
> > 2.6.22.4 and 2.6.22.5 to cure a locking problem, but it seems to have
> > introduced another (worse?) one.
>
> I spoke too soon. I checked more carefully, and this problem was
> introduced somewhere between 2.6.21 and 2.6.22. The jffs2 fix in
> 2.6.22.5 isn't the culprit.
>

Sounds like this belongs on the regression tracking page at
http://kernelnewbies.org/known_regressions and/or in a bugzilla
(http://bugzilla.kernel.org/) bugreport so it doesn't get lost.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
