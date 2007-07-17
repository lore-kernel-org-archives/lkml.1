Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbXGQNnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbXGQNnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXGQNmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:42:53 -0400
Received: from mail.screens.ru ([213.234.233.54]:34756 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbXGQNmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:42:53 -0400
Date: Tue, 17 Jul 2007 17:44:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Herbert Poetzel <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Use task_pid() to find leader's pid
Message-ID: <20070717134415.GA226@tv-sign.ru>
References: <20070715121750.GA173@tv-sign.ru> <20070716195952.GG25053@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716195952.GG25053@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16, sukadev@us.ibm.com wrote:
>
> Oleg Nesterov [oleg@tv-sign.ru] wrote:
> | 
> | Stupid question: why do we need to put the pid namespace into the struct
> | pid? Isn't it better if the user of the struct pid should know its ns?
> | For example, if /proc does put_pid(), that pid should be from the active
> | namespace.
> 
> Not sure I fully understand this. A process, and by extension its 'struct
> pid' is visible in multiple namespaces and we maintain this list of
> namespaces in each 'struct pid'.
> 
> Are you suggesting having a pid_namespace with a list of all 'struct pids'
> that are visible in it ?

I thought that the plan is: if the task is visible in some namespace, it has
a separate pid_t in that namespace.

OK, the question was relly stupid, please ignore. I'll wait for other patches
to understand what's going on.

Oleg.

