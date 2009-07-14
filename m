Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZGNR2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZGNR2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZGNR2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:28:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbZGNR2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:28:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=sEFn+mhKb51aokPPFx1jJfShG6EC4HE5Iu/2PoyycQdiBTeJl3z/s+JOsrR4SBN/a
	kyCsjvUOo07Hz5QGQcX8w==
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
Date: Tue, 14 Jul 2009 10:28:43 -0700
Message-ID: <6599ad830907141028y50f36d63h8ea06f73ff369591@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Blum <bblum@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 9:25 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> My point is
>  - More PIDs, More time necessary to read procs file.

Right now, many pids => impossible to read procs file due to kmalloc
failure. (This was always the case with cpusets too). So using kmalloc
in those cases is a strict improvement.

> This patch boost it ;) Seems like "visit this later again" ,or FIXME patch.

Agreed.

Paul
