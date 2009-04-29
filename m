Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZD2JLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZD2JLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbZD2JKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:10:16 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:50851 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166AbZD2JKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-mutt-references
         :x-mutt-fcc:user-agent;
        b=MOE8i4C8vAcAbDm6+lwrpjFFailvh9FePsPhWwiqy5AOHRFEoIqf8O7hxygTU8nZeK
         oCrvHxaOgHW4V4SoqytD3OoIwDCX2Oa4xmPioe2qs1BuxZ2CPv+FQXWYjzIQyLteYthV
         8Weitw4vap9gjDi8tqqMKdNpJFPBWmySOxRqU=
Date: Wed, 29 Apr 2009 11:08:09 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Alexander V. Lukyanov" <lav@netis.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090429090809.GA2995@ami.dom.local>
References: <20090422055735.GA4334@night.netis.ru> <20090427054103.GA27529@night.netis.ru> <20090428125755.GA5242@night.netis.ru> <49F76BF6.4040709@gmail.com> <20090429054510.GA8267@night.netis.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429054510.GA8267@night.netis.ru>
X-Mutt-References: <20090429054510.GA8267@night.netis.ru>
X-Mutt-Fcc: =outbox
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 09:45:10AM +0400, Alexander V. Lukyanov wrote:
> On Tue, Apr 28, 2009 at 10:49:58PM +0200, Jarek Poplawski wrote:
> > Do you mean if you wait a bit longer (until the first one is really removed)
> 
> The problem is that it is never removed. I waited for at least 30 minutes.
> 
> > before running another one, it doesn't s(t)uck? Is there a change e.g. wrt.
> > 2.6.28?
> 
> I mean, 'vconfig rem' on another interface stucks if the previous vconfig
> has not finished, and it never finishes. So I cannot check if other vlan
> interfaces have the same 'refcnt' problem. So far I tried 'vconfig rem' on
> two vlan interfaces and I have a dozen.
> 
> Again, the problem only happens after I notice surprisingly high LA (30
> instead of 2-6) and interactive slowness. When it happens, I check network
> usage, disk usage, cpu usage, mem usage - they are normal or even lower than
> usual.
> 
> The server is running transparent squid and named. The last kernel version
> was 2.6.27.21 and it did not have this problem.

So looks like a regression. Alas this thing could be hard to debug and
still more data is needed. For the beginning maybe: .config, dmesg,
and a few SysRq logs while this happens e.g. Alt-PrtScr with t, d, w, q
(gzipped or as attachments to a bugzilla report). (If it's not a big
problem trying 2.6.28.9 could be helpful too.)

Thanks,
Jarek P.
