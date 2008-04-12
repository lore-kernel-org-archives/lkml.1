Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYDLSNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYDLSNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbYDLSNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:13:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbYDLSNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:13:00 -0400
Message-ID: <4800FADB.3090406@zytor.com>
Date: Sat, 12 Apr 2008 11:09:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Helper patches for PTY namespaces
References: <20080412172933.GA19295@us.ibm.com>
In-Reply-To: <20080412172933.GA19295@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> Some simple helper patches to enable implementation of multiple PTY
> (or device) namespaces.
> 
> 	[PATCH 1/4]: Propagate error code from devpts_pty_new
> 	[PATCH 2/4]: Factor out PTY index allocation
> 	[PATCH 3/4]: Move devpts globals into init_pts_ns
> 	[PATCH 3/4]: Enable multiple mounts of /dev/pts
> 
> This patchset is based on earlier versions developed by Serge Hallyn
> and Matt Helsley.

Any measurable performance impact when not using these kinds of namespaces?

	-hpa
