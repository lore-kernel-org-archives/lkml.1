Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZF2UWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZF2UWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZF2UVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:21:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45215 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZF2UVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:21:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 29 Jun 2009 13:20:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jiri Olsa <jolsa@redhat.com>
cc: Jarek Poplawski <jarkao2@gmail.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
 callbacks
In-Reply-To: <20090629201733.GB3417@jolsa.redhat.com>
Message-ID: <alpine.DEB.1.10.0906291318460.30244@makko.or.mcafeemobile.com>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.1.10.0906290826300.29966@makko.or.mcafeemobile.com> <20090629173217.GC2742@ami.dom.local> <alpine.DEB.1.10.0906291033140.30244@makko.or.mcafeemobile.com>
 <20090629201733.GB3417@jolsa.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Jiri Olsa wrote:

> my thinking was that both variants will endup in the same code anyway,
> so it'd be probably better if the more readable (subjective) got in..
> 
> however I dont have any strong preffering feelings about either of those choices,
> so I can convert easilly :)

Please use the existing poll_wait() then, as there's no reason to add 
another API.


- Davide


