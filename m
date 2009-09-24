Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZIXRpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZIXRpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZIXRps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:45:48 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:46752 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZIXRps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:45:48 -0400
Message-ID: <4ABBB049.7080707@librato.com>
Date: Thu, 24 Sep 2009 13:45:45 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 3/9] Make pid_max a pid_ns property
References: <20090924165548.GA16586@us.ibm.com> <20090924170109.GC16989@us.ibm.com>
In-Reply-To: <20090924170109.GC16989@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> 
> From: Serge Hallyn <serue@us.ibm.com>
> Subject: [RFC][v7][PATCH 3/9] Make pid_max a pid_ns property
> 
> Remove the pid_max global, and make it a property of the
> pid_namespace.  When a pid_ns is created, it inherits
> the parent's pid_ns.
> 
> Fixing up sysctl (trivial akin to ipc version, but
> potentially tedious to get right for all CONFIG*
> combinations) is left for later.
> 
> Changelog[v2]:
> 	- Port to newer kernel
> 	- Make pid_max a local variable in alloc_pidmap() to simplify code/patch
> 
> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>


