Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXCGQBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXCGQBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXCGQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:01:43 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbXCGQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:01:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=aILxisF5v7mIVlycPTcmLvCGS4Y+eTIsNh1Dg/PvSh/rr8TYKY3JhylLfSuNO3cw6
	ctvHUc0TtdBpznfkop5KA==
Message-ID: <6599ad830703070801r3f4cd5bak8cbc9b3090ec4490@mail.gmail.com>
Date: Wed, 7 Mar 2007 08:01:32 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 2/7] containers (V7): Cpusets hooked into containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070307143412.GC32105@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.290909000@menage.corp.google.com>
	 <20070307143412.GC32105@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Mon, Feb 12, 2007 at 12:15:23AM -0800, menage@google.com wrote:
> >  /*
> > @@ -913,12 +537,14 @@ static int update_nodemask(struct cpuset
> >       int migrate;
> >       int fudge;
> >       int retval;
> > +     struct container *cont;
>
> This seems to be redundant?

It gets used in the lower loop checking for processes whose memory
policies we should be rebinding.

Paul
