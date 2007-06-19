Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXFSVOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXFSVOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXFSVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:14:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:58999 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbXFSVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=e8bVNwnl/GCYwJACXFkyhYAWLIdICp39KgjNQ1alC8C5hxYkj8nc74MS+fbg7XTzWn3sDR7EoqRf38AVQ1RDZ/7ZYp6gu4R0JTnc5ShZi2R/IkliEkTll/ralPehNEt5KUNpeKXDMciIxM0kyKEHvEnywU53X2sspSRHdcnvvY8=
Message-ID: <84144f020706191414g402143d3xdb96e03526107937@mail.gmail.com>
Date: Wed, 20 Jun 2007 00:14:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Cedric Le Goater" <clg@fr.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Herbert Poetzl" <herbert@13thfloor.at>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <Pine.LNX.4.64.0706191225030.7008@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4676F0B9.3080408@fr.ibm.com>
	 <20070619113501.a88bba50.akpm@linux-foundation.org>
	 <20070619190406.GA3830@infradead.org>
	 <Pine.LNX.4.64.0706191225030.7008@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: f40308780fe8822e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph x 2,

On Tue, 19 Jun 2007, Christoph Hellwig wrote:
> > Hmm, I must have missed the macro going in.  Frankly speaking I plain hate
> > it.  It's a rather useless obsfucation.

I hate the name, but the macro is far from useless.

On 6/19/07, Christoph Lameter <clameter@sgi.com> wrote:
> It makes the code easier to review and reduces errors by establishing a
> standard way of defining a slab with minimal effort. You can
> still do the  old style and create the kmem_cache_create parameter
> monsters that span lots of lines.
>
> KMEM_CACHE can do it just by specifying two parameters.

Yes and if you look at existing callers of kmem_cache_create(), you'll
notice that most of them work _exactly_ the way the macro does. Most
of the time you want to use default alignment and not define a
constructor.
