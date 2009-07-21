Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZGUUAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZGUUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZGUUA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:00:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40697 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbZGUUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:00:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=V6yncJOVS3HjgTvbkmBYdEZ/0NKCzPnJvU5/JDTql9btoq1qcaHc2yx542yH734ER
	c9sxpJoyhQn+sZa+uJKpQ==
Date: Tue, 21 Jul 2009 13:00:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <6599ad830907211257m6c8d6123g7b36d879913367a0@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907211258500.10356@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com> <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com> <20090721161319.2ABD.A69D9226@jp.fujitsu.com> <6599ad830907210906tf81842ds897012bbf0e5606d@mail.gmail.com>
 <alpine.DEB.2.00.0907211250530.10356@chino.kir.corp.google.com> <6599ad830907211257m6c8d6123g7b36d879913367a0@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Paul Menage wrote:

> Agreed, but the same livelock can be fixed in ways that don't break
> the API. (E.g. check for the victim being OOM_DISABLED in
> select_bad_process() when we find a new "worst" candidate).
> 

And allow /proc/pid-of-child/oom_score to represent a possible candidate 
(and, additionally, a hint at the oom killing priority) when it really 
isn't?
