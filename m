Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXCGQbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXCGQbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbXCGQbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:31:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:13167 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813AbXCGQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:31:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vhbWa2O+7c/eSaylNJ8kPUpQIKZLSESMfwo4gzr6bbY/9MViUudzzqSggdNQZdZRd
	4FlGr/PusI4hYvGRHsbLw==
Message-ID: <6599ad830703070831g5a295bd9k6a27989952722120@mail.gmail.com>
Date: Wed, 7 Mar 2007 08:31:26 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 2/7] containers (V7): Cpusets hooked into containers
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, pj@sgi.com, ebiederm@xmission.com,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       serue@us.ibm.com, devel@openvz.org
In-Reply-To: <20070307163112.GA6504@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.290909000@menage.corp.google.com>
	 <20070307143412.GC32105@in.ibm.com>
	 <6599ad830703070801r3f4cd5bak8cbc9b3090ec4490@mail.gmail.com>
	 <20070307163112.GA6504@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> It makes sense in the first cpuset patch
> (cpusets_using_containers.patch), but should be removed in the second
> cpuset patch (multiuser_container.patch). In the 2nd patch, we use this
> comparison:
>
>         if (task_cs(p) != cs)
>                 continue;
>
> cont variable introduced in the 1st patch essentially becomes unused
> after 2nd patch.
>

Yes, you're right - it could be removed in the 3rd patch.

Paul
