Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbYEMUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbYEMUoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbYEMUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:44:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49770 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311AbYEMUoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:44:15 -0400
Subject: Re: [RFC/PATCH 2/8]: CGroup Files: Add a cgroup write_string
	control file method
From: Matt Helsley <matthltc@us.ibm.com>
To: menage@google.com
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080513071522.301139000@menage.corp.google.com>
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.301139000@menage.corp.google.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 13 May 2008 13:44:11 -0700
Message-Id: <1210711451.21217.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-12 at 23:37 -0700, menage@google.com wrote:
> plain text document attachment (cgroup_write_string.patch)
> This patch adds a write_string() method for cgroups control files. The
> semantics are that a buffer is copied from userspace to kernelspace
> and the handler function invoked on that buffer.  Any control group
> locking is done after the copy from userspace has occurred. The buffer
> is guaranteed to be nul-terminated, and no longer than max_write_len
> (defaulting to 64 bytes if unspecified). Later patches will convert
> existing raw file write handlers in control group subsystems to use
> this method.
> 
> Signed-off-by: Paul Menage <menage@google.com>

I haven't looked at this very thoroughly but I think the goal of this
patch is good. Can't this patch and the conversions precede your locking
changes?

Cheers,
	-Matt Helsley

