Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYLPB6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYLPB6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYLPB6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:58:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYLPB6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:58:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=L8/VE8TYcssHG+3EZXxx8U85yotNy6g9TAZuTeE3OWdtaooWH2lqGc4+ozx1v9P3y
	+vOg5TGFXYwDpG6jT59Pg==
MIME-Version: 1.0
In-Reply-To: <6599ad830812151757t5362ae16y81b469b06022135c@mail.gmail.com>
References: <20081215113253.GL18403@balbir.in.ibm.com>
	 <6599ad830812151757t5362ae16y81b469b06022135c@mail.gmail.com>
Date: Mon, 15 Dec 2008 17:58:17 -0800
Message-ID: <6599ad830812151758ia2c5dcbo5d0119320623b762@mail.gmail.com>
Subject: Re: [BUG][PANIC] cgroup panics with mmotm for 2.6.28-rc7
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, menage@google.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 5:57 PM, Paul Menage <menage@google.com> wrote:
> That implies that we ran out of css_set objects

I mean, ran out of cg_cgroup_link objects.

> when moving the task
> into the new cgroup.

Paul
