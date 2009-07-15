Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZGODmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZGODmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZGODmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 23:42:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZGODmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 23:42:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tCwKNl8sZfyO/HgX3yiIRtXcjCLONk4IYnvDersCfoQ5QKfDRMYh3QGBqGs4eJd8E
	vaBNDEWUvTpxbp/ctS2uA==
Date: Tue, 14 Jul 2009 20:42:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH -mm] copy over oom_adj value at fork time (v2)
In-Reply-To: <20090714221235.4a2383ea@bree.surriel.com>
Message-ID: <alpine.DEB.2.00.0907142041530.31053@chino.kir.corp.google.com>
References: <20090714210557.0f983c37@bree.surriel.com> <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com> <20090715104920.39A4.A69D9226@jp.fujitsu.com> <20090714221235.4a2383ea@bree.surriel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Rik van Riel wrote:

> After moving the oom_adj value from the task struct to the
> mm_struct, the oom_adj value was no longer properly inherited
> by child processes.
> 
> Copying over the oom_adj value at fork time fixes that bug.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Paul Menage <manage@google.com>

Acked-by: David Rientjes <rientjes@google.com>
