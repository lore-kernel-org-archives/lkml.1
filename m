Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZEZTvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZEZTvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZEZTvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:51:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:1207 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZEZTvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="519029809"
From: =?iso-8859-1?q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>
To: "leemgs1@gmail.com" <leemgs1@gmail.com>
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to mount debugfs filesystem.
Date: Tue, 26 May 2009 12:50:33 -0700
User-Agent: KMail/1.9.9
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "trivial@kernel.org" <trivial@kernel.org>,
       "balagi@justmail.de" <balagi@justmail.de>,
       "bgamari@gmail.com" <bgamari@gmail.com>, Ingo Molnar <mingo@elte.hu>
References: <1243315163.14685.17.camel@centos51>
In-Reply-To: <1243315163.14685.17.camel@centos51>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905261250.34056.inaky.perez-gonzalez@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, GeunSik Lim wrote:
>  Hi all,
>
>  I want to hear your opinions about this proposal for consistency of
>  mount directory to mount debugfs filesystem that need  by ftrace
> infrastructure. Um... I appended "RFC" word in the subject because this
> mail is my proposal just.
>
>
> commit 1766a83645706100b1829bb422f852ec757c6f4b
> Author: GeunSik,Lim <leemgs1@gmail.com>
> Date:   Tue May 26 13:49:23 2009 +0900
>
>     Fix terminology inconsistency of dir name to mount debugfs filesystem.
>
>       Many developers use "/debug/" directory name to mount debugfs
> filesystem for ftrace according to ./Documentation/tracers/ftrace.txt file.
>
>       But, two directory names(ex:/debug/, /debugfs/) is existed in kernel
> source like ftrace, DRM, Wireless, Network[sky2]files to mount debugfs
> filesystem. I think that we don't have to select either "/debug/" directory
> name or "/debugfs/" directory name for terminology consistency.
>
>       debugfs means debug filesystem for debugging easy to use by greg
> kroah hartman. "/debug/" name is suitable as directory name of debugfs for
> tracing using ftrace like "/sys/" of sysfs(system filesystem). -debugfs
> related reference: http://lwn.net/Articles/115405/
>
>       Fix inconsistency of directory name according to duplicated
> expression to mount debugfs.
>
>          Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

For the WiMAX part, not really an issue:

Acked-By: Inaky Perez-Gonzalez <inaky@linux.intel.com>

