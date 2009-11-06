Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZKFSjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZKFSjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZKFSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:39:43 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38704 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZKFSjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:39:42 -0500
Date: Fri, 6 Nov 2009 12:39:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [v11][PATCH 9/9] Document clone_with_pids() syscall
Message-ID: <20091106183936.GA32531@us.ibm.com>
References: <20091105053053.GA11289@us.ibm.com> <20091105054204.GI16142@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105054204.GI16142@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@us.ibm.com):
...
> +	If a pid in the @pids list is non-zero, the kernel tries to assign
> +	the specified pid in that namespace.  If that pid is already in use
> +	by another process, the system call fails (see EBUSY below).
> +
> +	The order of pids in @pids is oldest in pids[0] to youngest pid
> +	namespace in pids[nr_pids-1]. If the number of pids specified in the

In the sys_choosepid() discussion, Matt suggested it would be more
user-friendly to have the pid for the youngest pidns be pids[0].
That way the user doesn't have to know their pidns depth.

-serge
