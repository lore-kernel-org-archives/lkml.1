Return-Path: <linux-kernel-owner+w=401wt.eu-S965473AbXBMJhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473AbXBMJhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965478AbXBMJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:37:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:13134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965473AbXBMJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:37:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OwhY4ItbpA7fKrBY2vIcWzoX9gJY80FncxY4YZ6xtSGjQWQc/KMpOl0LmhpT5LlB0
	BGBGJmCsimsCGDpFvU25g==
Message-ID: <6599ad830702130137t4bbfcec1ma65a873504796730@mail.gmail.com>
Date: Tue, 13 Feb 2007 01:37:27 -0800
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [PATCH 6/7] containers (V7): BeanCounters over generic process containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <45D1825A.7070907@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.998727000@menage.corp.google.com>
	 <45D17C48.9030105@sw.ru>
	 <6599ad830702130103l54f48df0y7c20606d31122a50@mail.gmail.com>
	 <45D1825A.7070907@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Pavel Emelianov <xemul@sw.ru> wrote:
>
> I have implementation that moves arbitrary task :)

Is that the one that calls stop_machine() in order to move a task
around? That seemed a little heavyweight ...

> May be we can do context (container-on-task) handling lockless?

What did you have in mind?

> > I thought that we solved that problem by having a tmp_bc field in the
> > task_struct that would take precedence over the main bc if it was
> > non-null?
>
> Of course, but I'm commenting this patchset which doesn't have
> this facility.

OK, I can add the concept in to the example too.

Paul
