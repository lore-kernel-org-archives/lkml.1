Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYHZA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYHZA4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 20:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYHZA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 20:56:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYHZA4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 20:56:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=aLtvlOPpG3B9hSHeAVyzq1z+lcC+8iteN6O2Yf7yCDrAs+2cMz1wBcA4/HvmkmQD/
	ql+2zrmX1BQsxjIWmVGsg==
Message-ID: <6599ad830808251755h645b94abh551da5ec64cb3999@mail.gmail.com>
Date: Mon, 25 Aug 2008 17:55:55 -0700
From: "Paul Menage" <menage@google.com>
To: righiandr@users.sourceforge.net
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently in the right cgroup
Cc: "Vivek Goyal" <vgoyal@redhat.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <a2776ec50808190812g15ecd48dw23db4337016f38a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <20080710104852.797fe79c@cuia.bos.redhat.com>
	 <20080710154035.GA12043@redhat.com>
	 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
	 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
	 <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
	 <a2776ec50808190812g15ecd48dw23db4337016f38a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 8:12 AM,  <righi.andrea@gmail.com> wrote:
>
> unfortunately I don't have too much details for now, so I was just
> looking for the most generic solution. The PAM lib approach seems
> reasonable for each daemon that represents an entry point to the
> system,

The PAM approach seems like the cleanest solution to me.

>
>> due to their "magical" nature - any task that does a setuid() now
>> risks being swept off into a different cgroup.
>
> If the admin configures so, moving tasks that do setuid() in different
> cgroups should be an expected behaviour, isn't it?

Is the sysadmin aware of all the places in all system daemons that do
setuid() calls?

Paul
