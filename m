Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbXLSQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbXLSQnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbXLSQnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:43:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:12629 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXLSQnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qx+xhXOUTYE6dniQKzSGNyCnG5Vty7R/iu0jFsO5z86OalmvIkexps5wdSh7PmRrUkjQprgcVxS1PGDvmuMlDI/nrHrelO6jrKvjj5Xycx3bBUjHQGAlGd/57sqeXO7GDhx2Ksk+y9d+3CFF9snbBvkrvxykO7hFOjuqmd63rP0=
Message-ID: <dfb262380712190843jf432d42vd6564afe5b5b9f6c@mail.gmail.com>
Date: Wed, 19 Dec 2007 18:43:08 +0200
From: "Ramagudi Naziir" <naziirr@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: a problem with NETPOLL/KGDBoE
Cc: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
In-Reply-To: <4769483E.4070600@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com>
	 <20071206183423.GZ19691@waste.org>
	 <dfb262380712190822l48f706b5k345762e233b693ae@mail.gmail.com>
	 <4769483E.4070600@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/07, Jason Wessel <jason.wessel@windriver.com> wrote:
> What module parameters did you pass to kgdboe and what kernel are you
> using and are you using the kgdb source forge patches?

I am running the kgdb_2.6.23 branch of your kgdb git tree
(git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git).

my kgdb parameter is "6443@10.0.0.28/,32323@10.0.0.11/",
where 10.0.0.28 is my target and 10.0.0.11 is the host running gdb.
I have to sniff gdb in order to find out the value of 32323...

> I had not looked to see if anything changed in the latest net poll api,
> but previously with the 2.6.21 kernel as example, the net poll api
> ignored the source port parameter entirely.  If this has changed, I

I don't know about 2.6.21, but now it seems that NETPOLL do not
ignore the source port.

> would be happy to make a further change to zero out the port or do what
> is needed to make it dynamic again, in a similar fashion to the way the
> MAC address parsing is dynamic for KGDB + the net poll api.

Oh that would be great.

Thanks,
naziir
>
> Jason.
>
> Also you can omit the linux-kernel mailling and take this up at:
> kgdb-bugreport@lists.sourceforge.net if you are using the source forge
> patches.

I didn't find source forge patches that are still applicable to nowadays
kernels, so I am using your git tree.

>
