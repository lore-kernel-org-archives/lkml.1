Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbXFDUcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbXFDUcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXFDUcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:32:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16199 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbXFDUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:32:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=awval2mwxDZ0Mnejqq6Ig1dfqWDTJ/CoZQXZlLcfZXNYN9DD319wlpwhQJR2/b1VV
	rFlh0J54T5kXt6u1kLhZg==
Message-ID: <6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com>
Date: Mon, 4 Jun 2007 13:32:06 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
In-Reply-To: <20070604191412.GA901@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529130104.461765000@menage.corp.google.com>
	 <20070604191412.GA901@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
> 2. I can't delete containers because of the files they contain, and
> am not allowed to delete those files by hand.
>

You should be able to delete a container with rmdir as long as it's
not in use - its control files will get cleaned up automatically.

If you're getting an EBUSY error that means that either there are
still tasks running in the container (look in the "tasks" file) or
else there's a reference counting bug somewhere.

Can you post an example to reproduce the problem?

Paul
