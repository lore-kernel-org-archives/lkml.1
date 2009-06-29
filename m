Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZF2TJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZF2TJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZF2TI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:08:56 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:45986 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZF2TIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=x9+xMiYb/WO7+Y6a5PhUOf90k3y/DudA1WzRrm+ubf++BEjTV9KcfBsKPlPG5CArWC
         xqBIo2mF039DpvjFiohTGYJXPUxpkqsmCaT0XOnvm0ufUfDzEVnvxt/TnS9FQdR9FHiq
         aSib9/E13hLPNf3ApkzvlFemw5heaBHAvf08s=
MIME-Version: 1.0
In-Reply-To: <2f11576a0906291154j727165e0nebdc3813d7af3158@mail.gmail.com>
References: <2f11576a0906290048t29667ae0sd75c96d023b113e2@mail.gmail.com>
	 <26537.1246086769@redhat.com> <20090627125412.GA1667@cmpxchg.org>
	 <20090628113246.GA18409@localhost>
	 <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com>
	 <2f11576a0906280749v25ab725dn8f98fbc1d2e5a5fd@mail.gmail.com>
	 <28c262360906280947o6f9358ddh20ab549e875282a9@mail.gmail.com>
	 <17087.1246279435@redhat.com>
	 <20090629095729.cc9f183c.akpm@linux-foundation.org>
	 <2f11576a0906291154j727165e0nebdc3813d7af3158@mail.gmail.com>
Date: Tue, 30 Jun 2009 04:08:58 +0900
X-Google-Sender-Auth: 80d6de64208c77a0
Message-ID: <2f11576a0906291208q4e924258w589c8017ae8a0b6e@mail.gmail.com>
Subject: Re: Found the commit that causes the OOMs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

typo.

> OK. we need learn testcase more.
>
> [read test program source code... ]
>
> this program makes `cat /proc/sys/kernel/msgmni` * 10 processes.
> At least, one process creation need one userland stack page (i.e. one anon)
> + one kernel stack page (i.e. one unaccount page) + one pagetable page.
>
> In my 1GB box environment,  default msgmni is 11969.
> Oh well, the system physical ram (255744) is less than needed pages (11969 * 3).

wrong) 11969 * 3
correct) 119690 * 3
