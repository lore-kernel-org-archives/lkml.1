Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZGHUHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZGHUHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZGHUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:07:04 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35461 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbZGHUHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PGGKOWkcla8nO9BLCFxar92NfkdntMGcKwWwhWD1SOQEdeO4wih7flHMVjSfe2xhD/
         y1Y6hc5DWDPkmxiUtQbRl4LsqjhgT7gIZCHVN44mehMzfTUGes2uBamcp86nkhThvUof
         cl35Qnlz0Jou+GC2SYXHz9k7vsyH13R49fGsA=
Date: Wed, 8 Jul 2009 22:06:41 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       htejun@gmail.com, oleg@redhat.com, davidel@xmailserver.org,
       davem@davemloft.net
Subject: Re: [PATCH 1/2] [PATCHv6 1/2] net: adding memory barrier to the
	poll and receive callbacks
Message-ID: <20090708200641.GA12750@ami.dom.local>
References: <20090708194726.GA3196@jolsa.lab.eng.brq.redhat.com> <20090708194850.GB3196@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708194850.GB3196@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 09:48:50PM +0200, Jiri Olsa wrote:
> Adding memory barrier after the poll_wait function, paired with
> receive callbacks. Adding fuctions sk_poll_wait and sk_has_sleeper
- receive callbacks. Adding fuctions sk_poll_wait and sk_has_sleeper
+ receive callbacks. Adding fuctions sock_poll_wait and sk_has_sleeper

Did I miss this in v5?!

Sorry ;-)
Jarek P.
