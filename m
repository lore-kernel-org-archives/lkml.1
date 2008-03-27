Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYC0Mnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYC0Mnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYC0Mnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:43:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:35321 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYC0Mni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tfU8di+snH50bwscNYU/cVx1+tYFZB+Gl6uXiEYDddFDVb/FU/8xF0CUEi8OkaAGTIQzm5ODLTeJdrgtdRCM3G0w2S/eB/vr66O1+LKgGiq+fvu/hNYvgktC8HxuuX5Fe0DFLGRYTqaeJ0XHY7JVny0yZ+oWPkQHOMb4l3Qn4BI=
Date: Thu, 27 Mar 2008 13:49:28 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327124928.GE2845@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/> <20080325134320.21525479.akpm@linux-foundation.org> <47EAD8A5.3070806@gmail.com> <20080326171403.ad186037.akpm@linux-foundation.org> <20080327085542.GA2778@ami.dom.local> <20080327021812.601776b8.akpm@linux-foundation.org> <1206615379.8514.502.camel@twins> <20080327122255.GC2845@ami.dom.local> <1206621014.8514.563.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206621014.8514.563.camel@twins>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:30:14PM +0100, Peter Zijlstra wrote:
...
> My guess is that it is a race between polling the device and irq pushing
> the packet. That is, normally the IRQ handler wins and netpoll doesn't
> have anything to do and it doesn't traverse this code path.
> 
> (although I must admit to being a little out of my depth here)

Probably you're right but there were really a lot of testing and
stressing netconsole for misterious lockups for quite a long time
with this new napi, so it's hard to believe this was hidden so
well...

Jarek P.
