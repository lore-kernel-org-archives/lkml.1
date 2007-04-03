Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXDCPpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXDCPpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXDCPpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:45:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbXDCPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:45:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Arg39Palhv6zz+CYHHaxzxhc8n02Ecji5K7fw0WRMMcQhCKyatJ8TU0zlByiVVQDJ
	lcknjSgrJ30MpJbGc54+w==
Message-ID: <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
Date: Tue, 3 Apr 2007 08:45:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, vatsa@in.ibm.com,
       akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
In-Reply-To: <20070403153220.GA24946@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085105.170265000@menage.corp.google.com>
	 <20070331024722.GA808@in.ibm.com>
	 <20070402140938.GF17710@sergelap.austin.ibm.com>
	 <20070402142727.GF2456@in.ibm.com>
	 <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
	 <20070403153220.GA24946@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
> But frankly I don't know where we stand right now wrt the containers
> patches.  Do most people want to go with Vatsa's latest version moving
> containers into nsproxy?  Has any other development been going on?
> Paul, have you made any updates?

I've not made major changes since the last patch post, just some small
optimizations and fixes - I've been too tied up with other stuff.

Whilst I've got no objection in general to using nsproxy rather than
the container_group object that I introduced in my latest patches, I
think that Vatsa's approach of losing the general container object is
flawed, since it loses any kind of per-group generic state (e.g. "this
container is being deleted") and last time I saw it, I think it would
tend to lose processes so that they didn't show up in any directory in
the container fs.

Paul
