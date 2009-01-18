Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbZARNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbZARNNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 08:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZARNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 08:13:06 -0500
Received: from kandzendo.ru ([195.178.208.66]:47900 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZARNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 08:13:06 -0500
Date: Sun, 18 Jan 2009 16:13:03 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
Message-ID: <20090118131303.GA19292@ioremap.net>
References: <bTxdg-8sZ-21@gated-at.bofh.it> <bTxmW-hf-1@gated-at.bofh.it> <bTRYr-2up-21@gated-at.bofh.it> <E1LNBGL-00021y-C8@be1.7eggert.dyndns.org> <20090114192216.GA18123@ioremap.net> <alpine.LSU.0.999.0901152243330.9772@be1.lrz> <20090115223557.GC10429@ioremap.net> <alpine.LSU.0.999.0901171504480.7336@be1.lrz> <20090117142245.GA10801@ioremap.net> <alpine.LSU.0.999.0901181333160.6179@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.0901181333160.6179@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 01:37:09PM +0100, Bodo Eggert (7eggert@gmx.de) wrote:
> How many different CGI handlers are you going to have?

CGIs are usually limited, application server is not.

> And how does kill-kenny scale with the number of users on the system?
> I want my browser not to be killed, while the other user wants his
> gimp not to be killed. As you can see, it does not even scale for
> the most simple multi-user system.

It is not about who should not be killed, but who should _be_ in the
first raw.

> > No, admin will limit/forbid the connection from the DoSing clients,
> > server must always live to handle proper users.
> 
> If there is no memory, the admin can't even log in.

Admin can observe the situation via kvm or sometimes netconsole and
tune the system for the next run.

-- 
	Evgeniy Polyakov
