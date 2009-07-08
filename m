Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZGHVvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZGHVvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbZGHVvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:51:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbZGHVvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:51:31 -0400
Date: Wed, 8 Jul 2009 23:51:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       htejun@gmail.com, oleg@redhat.com, davidel@xmailserver.org,
       davem@davemloft.net
Subject: Re: [PATCH 1/2] [PATCHv6 1/2] net: adding memory barrier to the
	poll and receive callbacks
Message-ID: <20090708215102.GA2945@jolsa.redhat.com>
References: <20090708194726.GA3196@jolsa.lab.eng.brq.redhat.com> <20090708194850.GB3196@jolsa.lab.eng.brq.redhat.com> <20090708200641.GA12750@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708200641.GA12750@ami.dom.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 10:06:41PM +0200, Jarek Poplawski wrote:
> On Wed, Jul 08, 2009 at 09:48:50PM +0200, Jiri Olsa wrote:
> > Adding memory barrier after the poll_wait function, paired with
> > receive callbacks. Adding fuctions sk_poll_wait and sk_has_sleeper
> - receive callbacks. Adding fuctions sk_poll_wait and sk_has_sleeper
> + receive callbacks. Adding fuctions sock_poll_wait and sk_has_sleeper
> 
> Did I miss this in v5?!
indeed you did! :)

sending v7 shortly, thanks
jirka
> 
> Sorry ;-)
> Jarek P.
