Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXFMXSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXFMXSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXFMXSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:18:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:10041 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbXFMXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U60mfW9zPOBgqWhATJqeVTjiYMJvP0nteoCFlonreGzu+iTOvjXkWPlkDXsEpA5uu4AW/3u9t9OaI/RuhzpdJfp8OVDDtkyWMLdvx5eza2WPuvQrRDvor7s/3IFn6KVW3xOA8HZbim2+6AH2GF6Cup0lR4N9+zbPeTKr9/u9KRk=
Message-ID: <9d732d950706131618t6027f1a3xd840dde9cd7c0337@mail.gmail.com>
Date: Thu, 14 Jun 2007 08:18:19 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [RFC] TOMOYO Linux
Cc: "Rik van Riel" <riel@redhat.com>, "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Toshiharu Harada" <haradats@nttdata.co.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <Line.LNX.4.64.0706131835040.13360@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FA71C.1020309@nttdata.co.jp>
	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
	 <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com>
	 <46704D49.8010308@redhat.com>
	 <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
	 <467064B9.1080005@redhat.com>
	 <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com>
	 <Line.LNX.4.64.0706131835040.13360@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morris, thank you for your comment.

2007/6/14, James Morris <jmorris@namei.org>:
> On Thu, 14 Jun 2007, Toshiharu Harada wrote:
>
> > TOMOYO Linux has a mode called "learning"
> > in addition to "permissive" and "enforce". You can easily
> > get the TOMOYO Linux policy with learning mode that
> > SELinux does not have.
>
> Blindly generating security policy through observation of the system is
> potentially dangerous for many reasons.
> See
> <http://securityblog.org/brindle/2006/03/25/security-anti-pattern-status-quo-encapsulation/>
>

When I saw Russell Coker and showed him a demonstration of
TOMOYO Linux, he told the same comment.
Also after tracing an AppAmor's long thread, I'm convinced of the
meaning of label base. That's why I don't think TOMOYO Linux as a
replace of SELinux. "Professional policy (or reference policy)"
makes sense to me.

However it may be safe for audition and profiling purpose.
Policy learning feature of TOMOYO Linux will help
understanding the behavior of Linux boxes.
That is my point.

I will double check the link you showed me. Thank you.
(It's wonderful to receive comments from you and Stephen!)

> Note that while SELinux does also have a similar capability with the
> audit2allow tool, it should be considered an expert tool, the output of
> which needs to be understood before use (as noted in its man page).

Yes. But I remember Frank said "don't use it :-)" when he gave a
presentation in Japan.

> > In addition, access control mode of
> > TOMOYO Linux can be managed for every difference domain.
>
> We have considered per-domain enforcing mode a couple of times in the
> past, but figured that it could be implemented via policy alone (e.g. run
> the task in a domain where all accesses are allowed and logged); and it
> would also be of limited usefulness because of the aforementioned problems
> with learning mode security policy.

I'll reply this part in later.

Thanks!
Toshiharu Harada
