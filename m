Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYDNHyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYDNHyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbYDNHxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:53:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbYDNHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:53:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=l/Z69z1Z9VZLU3t1eMY2z9C3s4bcNgwvDTEOoR5wNLYnSh8QiTe86w5sjWKfne4fS
	tquyzUw0DJ/190//vS3qA==
Message-ID: <6599ad830804140053y4bcdceeatc9763c1e8c1aaf44@mail.gmail.com>
Date: Mon, 14 Apr 2008 00:53:41 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: fix oops in oom handling
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20080414161428.27f3ee59.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4802FF10.6030905@cn.fujitsu.com>
	 <20080414161428.27f3ee59.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 12:14 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>  Paul, I have one confirmation. Lock hierarchy of
>         cgroup_lock()
>         ->      read_lock(&tasklist_lock)
>
>  is ok ? (I think this is ok.)

Should be fine, I think.

Have you built/booted with lockdep?

Paul
