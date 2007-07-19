Return-Path: <linux-kernel-owner+w=401wt.eu-S933962AbXGSM5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbXGSM5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbXGSM44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:56:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:50042 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077AbXGSM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VJ8UvClxdU4Z5EcAu4C/6qGexu7+aJTYIomagQ9ln9UAcYXNsQsqK49eh/irgCeh0YB96vv2U5S7K+77/LtFx7wc9i+EkGdNrOK45KKhZgdgmtYdp/JNADqTAuq/ArJcAlsrs32cKij9oV9GMU//h4ZmqWOP4wlADhmAObca/Nc=
Message-ID: <7b69d1470707190556n78e52232y7dfea1fd6f47ced@mail.gmail.com>
Date: Thu, 19 Jul 2007 07:56:53 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Christian Ehrhardt" <lk@c--e.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Wright" <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <Line.LNX.4.64.0707190832290.4303@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
	 <20070718183503.541026f8.akpm@linux-foundation.org>
	 <20070719073948.GI18840@lisa.in-ulm.de>
	 <20070719122424.GA5186@vino.hallyn.com>
	 <Line.LNX.4.64.0707190832290.4303@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, James Morris <jmorris@namei.org> wrote:
> On Thu, 19 Jul 2007, Serge E. Hallyn wrote:
>
> > If we could get a few (non-afilliated :) people who work with
> > customers in the security field to tell us whether this is being
> > used, that would be very helpful.  Not sure how to get that.
>
> The mainline kernel does not cater to out of tree code.

Please distinguish between "cater to" and "support". If the kernel
didn't worry about supporting out-of-tree code, then why would there
be loadable module at all?

Christian Ehrhardt already pointed to two reasons for loadable LSMs
that are sufficient to justify keeping them - so you can replace them
iteratively while you're developing them or choose between
alternatives.

Another twist is to use a tool to generate the module from a
policy-definition file; this could be done at boot-time or could be
done to replace the current policy on a running system (perhaps to add
a new domain corresponding to a newly added service). Yes, this would
need to be done with a lot of care, but part of providing mechanism
(rather than policy) is enabling people to use the mechanism in the
ways they prefer.

scott
-- 
scott preece
