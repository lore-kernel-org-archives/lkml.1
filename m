Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZGNR0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZGNR0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZGNR0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:26:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbZGNR0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:26:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bt6OrLXgSKF5QW4JM9RlecEgDaQ1C8oH+WCrn3sz1tJTMLTTMxA5Aqb7jz0LcRD9/
	I5BS1EPmg7XPZ2tS0/1/A==
MIME-Version: 1.0
In-Reply-To: <20090714132538.ac0bc44a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	 <4A5AA3E7.9070800@cn.fujitsu.com>
	 <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	 <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
	 <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132104o55d31ccexb15e5aa35c31416e@mail.gmail.com>
	 <20090714132538.ac0bc44a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 14 Jul 2009 13:26:30 -0400
Message-ID: <2f86c2480907141026h7ca27a4fq898c3ee248280a75@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Benjamin Blum <bblum@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 12:25 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> My point is
>  - More PIDs, More time necessary to read procs file.
> This patch boost it ;) Seems like "visit this later again" ,or FIXME patch.
>
> Thanks,
> -Kame

Indeed. You'll notice the TODOs in the code here referring to the
discussion of a possible dynamic array system in the previous thread.
This is simply a correctness patch that aims to keep performance as
good as it can for the current approach.

(Kame, forgive the double-post; forgot to reply-all the first time)

- Ben
