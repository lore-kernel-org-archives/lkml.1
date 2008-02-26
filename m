Return-Path: <linux-kernel-owner+w=401wt.eu-S1765348AbYBZVZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765348AbYBZVZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762367AbYBZVZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:25:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYBZVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:25:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=TElL7xEa8N66XwqRtDyWWCJD98Uc7xnYzXkh+gfjkSgt2C6v53Ie+fW3TxkHgmX08
	QZkvapxMZIAjFDAEoiqWg==
Date: Tue, 26 Feb 2008 13:23:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mempolicy: update NUMA memory policy documentation
In-Reply-To: <20080226113441.934c8c90.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802261322170.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250016380.12368@chino.kir.corp.google.com> <20080226113441.934c8c90.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Paul Jackson wrote:

> Hmmm ... I've read this several times now ... still can't figure out
> what it's saying ;).  And it doesn't really explain key aspects of
> MPOL_F_RELATIVE_NODES, such as that it provides cpuset relative
> numbering (use nodes 0..N-1, regardless of your current cpuset, to
> refer to the first N nodes in whatever is your current cpuset.)
> 

I'll elaborate more on the MPOL_F_RELATIVE_NODES effect.
