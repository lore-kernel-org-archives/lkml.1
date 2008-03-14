Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYCNOQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYCNOQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYCNOPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:15:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbYCNOPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:15:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ASzEv1jn+uvVR4xmvLVaP0/6Xiy5CRsIRjW0els6APxtLn6m+6bwRf63UNpZ3QhCd
	Jt4ju/3I5bXyVV3gEd6yg==
Message-ID: <6599ad830803140715i5532f02ag6a93f028ab88d57f@mail.gmail.com>
Date: Fri, 14 Mar 2008 07:15:34 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20080314140523.GG8744@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
	 <6599ad830803140216k1a04ce4ej4779bf10ec6ef4f9@mail.gmail.com>
	 <20080314140523.GG8744@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 7:05 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>  > >  A task may only be moved to another devcgroup if it is moving to
>  > >  a direct descendent of its current devcgroup.
>  >
>  > What's the rationale for that?
>
>  To prevent it escaping to laxer device permissions, which of course only
>  makes sense if we do what you recommend above :)
>

That makes it impossible for a root process to enter a child cgroup,
do something, and then go back to its own cgroup. Why aren't the
existing cgroup security semantics sufficient?

Paul
