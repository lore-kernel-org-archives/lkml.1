Return-Path: <linux-kernel-owner+w=401wt.eu-S1422823AbXCGRru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422823AbXCGRru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422954AbXCGRrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:47:14 -0500
Received: from smtp-out.google.com ([216.239.33.17]:21140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422823AbXCGRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:46:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XLCR8J/qwir9NVYWlFcnB2AenJw31Aw613DBqHr93dd0c97ZpbRFBw99DVdDAT2eJ
	SZ20FMv/FmQIwLAe2mI+A==
Message-ID: <6599ad830703070946s1c6c0535oadff0a109731a4f9@mail.gmail.com>
Date: Wed, 7 Mar 2007 09:46:35 -0800
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, ebiederm@xmission.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070307174346.GA19521@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	 <20070307173031.GC2336@in.ibm.com>
	 <20070307174346.GA19521@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> > On Tue, Mar 06, 2007 at 06:32:07PM -0800, Paul Menage wrote:
> > > I'm not really sure that I see the value of having this be part of
> > > nsproxy rather than the previous independent container (and
> > > container_group) structure.
> >
> > *shrug*
> >
> > I wrote the patch mainly to see whether the stuff container folks (Sam Vilain
> > et al) were complaining abt (that container structure abstraction
> > inside the kernel is redundant/unnecessary) made sense or not.
>
> I still think the complaint was about terminology, not implementation.

No, Sam was saying that nsproxy should be the object that all resource
controllers hook off.

Paul
