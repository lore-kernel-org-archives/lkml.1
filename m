Return-Path: <linux-kernel-owner+w=401wt.eu-S932680Ab0AGA0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab0AGA0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584Ab0AGA0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:26:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab0AGA0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:26:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fxl5rgPO5WlAHQceoGGXrdeH1aeiH83MCrTeFveAE2O6Z+ab3WkUUPP131ZwdHPaw
	Pa1+lfmJkbqxewGNmw8ag==
Date: Wed, 6 Jan 2010 16:25:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Blanchard <anton@samba.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] x86: cpumask_of_node() should handle -1 as a node
In-Reply-To: <20100107000106.GD12742@kryten>
Message-ID: <alpine.DEB.2.00.1001061623130.24920@chino.kir.corp.google.com>
References: <20100106045509.245662398@samba.org> <20100106045509.245662398@samba.org> <20100106045525.476396870@samba.org> <201001061706.26845.rusty@rustcorp.com.au> <alpine.DEB.2.00.1001061454580.11653@chino.kir.corp.google.com> <20100106233151.GC12742@kryten>
 <alpine.DEB.2.00.1001061545210.19882@chino.kir.corp.google.com> <20100107000106.GD12742@kryten>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Anton Blanchard wrote:

> I wasn't using the example to strengthen the case of the -1 behaviour, but to
> highlight that a complete fix would be more work and risk not making it back
> to -stable.
> 

I don't think that we should defer a complete fix to the callers because 
it's "more work."  If you've identified places where -1 is passed to 
cpumask_of_node() without being checked, I think those would be fairly 
obvious -stable candidates themselves instead of this series.
