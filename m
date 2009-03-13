Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZCMAsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZCMAsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZCMAs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:48:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZCMAsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:48:25 -0400
Subject: Re: [PATCH for tip] tracing: Don't use tracing_record_cmdline() in
	workqueue tracer fix
From: Steven Rostedt <srostedt@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090313090042.43CD.A69D9226@jp.fujitsu.com>
References: <20090313090042.43CD.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 12 Mar 2009 20:48:08 -0400
Message-Id: <1236905288.11290.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-03-13 at 09:03 +0900, KOSAKI Motohiro wrote:
> commit c3ffc7a40b7e94b094efe1c8ab4e24370a782b65 "Don't use tracing_record_cmdline() 
> in workqueue tracer" have a race window.
> 
> find_task_by_vpid() require task_list_lock(). but the patch doesn't.
> 
> fixing here.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---

Applied, thanks!

-- Steve


