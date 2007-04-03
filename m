Return-Path: <linux-kernel-owner+w=401wt.eu-S966046AbXDCRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966046AbXDCRar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966182AbXDCRar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:30:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966046AbXDCRap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:30:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SKUtoL6xXlOXkqsgNtY8K4PtnkIT5YJeQRAPQur1fsztyB+cP5t1YjC7afXWhdkqj
	WtNOaBD6H1g06LlCQchRA==
Message-ID: <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
Date: Tue, 3 Apr 2007 10:30:28 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
In-Reply-To: <20070403173048.GL2456@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070331024722.GA808@in.ibm.com>
	 <20070402142727.GF2456@in.ibm.com>
	 <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
	 <20070403153220.GA24946@sergelap.austin.ibm.com>
	 <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
	 <20070403164615.GJ2456@in.ibm.com>
	 <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
	 <20070403171155.GK2456@in.ibm.com>
	 <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
	 <20070403173048.GL2456@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> Hmm no .. I currently have nsproxy having just M additional pointers, where
> M is the maximum number of resource controllers and a single dentry
> pointer.

So how do you implement something like the /proc/<PID>/container info
file in my patches? (Or more generally, tell which container a task is
in for a given hierarchy?)

Paul
