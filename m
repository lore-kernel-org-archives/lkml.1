Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZJMFUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZJMFUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZJMFUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:20:35 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:57390 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZJMFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NvlLhg2SZzTb5dpZ913hMQAs3yhp7d3bUsoWjQm7Y0GyGM2u5sqtR4HFqMOgvl0JrO
         VtkCataN2VCJKcwfrcEZPT2CahGKeMVH9LIDCM1kHTEKVZBf0a9Ac+hG4D76yBIf5PuC
         cwrXnwhSOL1q39Y/TuglKQjSeRLt+OSW6otbg=
Date: Tue, 13 Oct 2009 09:19:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
Message-ID: <20091013051953.GA19895@x200>
References: <20091013044925.GA28181@us.ibm.com>
 <20091013045041.GC28435@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013045041.GC28435@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 09:50:41PM -0700, Sukadev Bhattiprolu wrote:
> From: Serge Hallyn <serue@us.ibm.com>
> Subject: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
> 
> Remove the pid_max global, and make it a property of the
> pid_namespace.  When a pid_ns is created, it inherits
> the parent's pid_ns.
> 
> Fixing up sysctl (trivial akin to ipc version, but
> potentially tedious to get right for all CONFIG*
> combinations) is left for later.

pid_max is not pid_ns property, it's just sysctl to limit cpu time
during bitmap search. Just like vm.max_map_count limits kernel memory
used by VMAs.
