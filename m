Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZL0Ade@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZL0Ade (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 19:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZL0Add
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 19:33:33 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51460 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZL0Adc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 19:33:32 -0500
Subject: Re: A basic question about the security_* hooks
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>, Va@jasper.es
In-Reply-To: <20091225055034.GA374@us.ibm.com>
References: <20091225001422.GB22311@us.ibm.com> <20091225011128.GA5213@heat>
	 <20091225055034.GA374@us.ibm.com>
Content-Type: text/plain
Date: Sat, 26 Dec 2009 19:33:29 -0500
Message-Id: <1261874009.3684.58.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 23:50 -0600, Serge E. Hallyn wrote:

<snip>

> Well, taking a step back - what exactly is the motivation for making this
> an LSM?  Is it just to re-use the callsites?  Or to provide a way to turn
> off the functionality?  I ask bc the API is in the prctl code, so the LSM
> is conceptually always there, which is different from other LSMs.
> 
> So if you (or your audience) really want this to be an LSM, then you should
> probably put your prctl code in a security_task_prctl() hook.  Otherwise,
> perhaps we should just explicitly call your hooks in wrappers - or whatever was
> finally decided should be done with the security/integrity/ima hooks.
> 
> -serge

Any place that a security hook and the IMA call co-existed, the IMA call
was moved to the security_ hook (security/security.c).

Mimi

