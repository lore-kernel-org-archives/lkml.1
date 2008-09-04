Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYIDSZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYIDSZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYIDSZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:25:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYIDSZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:25:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Rz1oqOpp3s1/2eAHclF7ZE4DwN36LWnxcNnTGdARqUuuM09f6BJdP7mpS2Y1YRrzd
	VC+f6RBmYN7mW5wjYjuxA==
Message-ID: <6599ad830809041125m45c75229o3e0f392241b7bc67@mail.gmail.com>
Date: Thu, 4 Sep 2008 11:25:30 -0700
From: "Paul Menage" <menage@google.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently in the right cgroup
Cc: righi.andrea@gmail.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Ulrich Drepper" <drepper@redhat.com>,
       "Steve Olivieri" <solivier@redhat.com>
In-Reply-To: <20080826134127.GA30312@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710104852.797fe79c@cuia.bos.redhat.com>
	 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
	 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
	 <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
	 <20080819125710.GA18972@redhat.com>
	 <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com>
	 <20080826134127.GA30312@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 6:41 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> So there can be two kind of controls.
>
> - Create a per cgroup file say "group_pinned", where if 1 is written to
>  "group_pinned" that means daemon will not move tasks from this cgroup upon
>  effective uid/gid changes.

I don't think you'd necessarily need a cgroup file for that - it could
be part of the daemon configuration.

Paul
