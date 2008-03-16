Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYCPA55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYCPA55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 20:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYCPA5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 20:57:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYCPA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 20:57:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=aRqJoS+0FjXg9cpngAuwfDxxe8WYAdv/5Ndz9sMQg8aRSK0UbQiMDik9CtixKY9D1
	G+bcnplQ48miNqCEEbPvg==
Message-ID: <6599ad830803151757n1901db95tad78d11761e2cb92@mail.gmail.com>
Date: Sun, 16 Mar 2008 08:57:36 +0800
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20080314143534.GD9741@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
	 <6599ad830803140216k1a04ce4ej4779bf10ec6ef4f9@mail.gmail.com>
	 <20080314140523.GG8744@sergelap.austin.ibm.com>
	 <6599ad830803140715i5532f02ag6a93f028ab88d57f@mail.gmail.com>
	 <20080314143534.GD9741@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 10:35 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
>  > Why aren't the
>  > existing cgroup security semantics sufficient?
>
>  Because the point of this is to provide some restrictions to otherwise
>  privileged users, and cgroups only provides dac-based permissions.
>
>  But that doesn't mean that I'm not doing too much.  I could just add a
>  CAP_SYS_ADMIN or CAP_CONT_OVERRIDE+CAP_SYS_ADMIN check, and not restrict
>  which cgroups a task can move to.  Does that sound good?

Sounds reasonable.

Paul
