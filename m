Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXDCRuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXDCRuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161035AbXDCRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:50:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161010AbXDCRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:49:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JryLs5XFHtkZNT502AwkA30/wl7KkfvCUzAFWDOz7a1FjJib0bOGxycF7GvYC/zwn
	wcwRc3hBI7cq7doC0zLcQ==
Message-ID: <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
Date: Tue, 3 Apr 2007 10:49:49 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
In-Reply-To: <20070403175101.GN2456@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070402142727.GF2456@in.ibm.com>
	 <20070403153220.GA24946@sergelap.austin.ibm.com>
	 <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
	 <20070403164615.GJ2456@in.ibm.com>
	 <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
	 <20070403171155.GK2456@in.ibm.com>
	 <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
	 <20070403173048.GL2456@in.ibm.com>
	 <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
	 <20070403175101.GN2456@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> > (Or more generally, tell which container a task is
> > in for a given hierarchy?)
>
> Why is the hierarchy bit important here? Usually controllers need to
> know "tell me what cpuset this task belongs to", which is answered
> by tsk->nsproxy->ctlr_data[CPUSET_ID].

I was thinking of queries from userspace.

Paul
