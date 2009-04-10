Return-Path: <linux-kernel-owner+w=401wt.eu-S938038AbZDJCtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938038AbZDJCtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937746AbZDJCoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:44:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:39044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937743AbZDJCn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XX/lSb+0Ll/6MDVrUBypIEtvlhC/OVqJ2uuh4BwUaV4yGnvEZChUl/lG8QhXngUBaO
         BnBD+bJhb43aeMKNBVS91ggn2U3cle6IUM6EQetu8TpP5N/KsjsRJhasG/0v4hv5C9zX
         H+4aQC6byTRudf1qRfyimExdLjieiNEsx/JLY=
Date: Fri, 10 Apr 2009 06:44:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090410024401.GA28177@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023207.GA27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:32:07AM +0400, Alexey Dobriyan wrote:
> This is to show how we see C/R and to provoke discussion on number of
> important issues (mounts, ...).
> 
> This is small part of long-awaited to be cleanuped code.
> 
> It's able to restore busyloop on i386 and x86_64 and restore i386
> busyloop on x86_64. It wasn't tested much more than that.
> 
> I'm currently starting formal testsuite, otherwise it's whack-a-mole
> game and formal TODO list (a huge one).

Andrew, patches 1-9 stand by themselves and can be applied at any moment
(except 4 and 7 where I made functions needlessly global).
