Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZF2SPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZF2SPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbZF2SPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:15:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38188 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbZF2SPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sCC4zRUfjFSa1Abn9MBQCODgp2wRvW7wlyxPIpZLn2BiSWz2KmfppgClCz3WwA+aP1
         ZGCDGNzaKFR0tQgPPNFEIwEmctsUHN3iuC95/4Qi8qMPXTISwLhBbfpxSN2hGuM6H+3/
         CuL2/TeV2dFZU6pwMYZEQdIpROOfR1jjHtTdc=
Date: Mon, 29 Jun 2009 20:14:42 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
	callbacks
Message-ID: <20090629181442.GF2742@ami.dom.local>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.1.10.0906290826300.29966@makko.or.mcafeemobile.com> <20090629173217.GC2742@ami.dom.local> <alpine.DEB.1.10.0906291033140.30244@makko.or.mcafeemobile.com> <20090629180431.GE2742@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629180431.GE2742@ami.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 08:04:31PM +0200, Jarek Poplawski wrote:
...
> Btw., maybe I miss something but I guess Oleg proposed something in
> between: inlining __poll_wait(), which would save us 'extra API' and
> compiler doubts. (But I still prefer Jiri's choice. ;-)

After re-reading I guess Oleg didn't proposed anything in between yet.

Sorry,
Jarek P.
