Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZI2N2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZI2N2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZI2N2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZI2N2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:28:40 -0400
Date: Tue, 29 Sep 2009 15:24:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Evgeny Polyakov <johnpol@2ka.mipt.ru>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
Subject: Re: 2.3.31++: Badness at kernel/softirq.c:143 due to new session
	leader connector
Message-ID: <20090929132415.GB4538@redhat.com>
References: <200909251123.03482.borntraeger@de.ibm.com> <200909291226.28548.borntraeger@de.ibm.com> <fbbbe0a028fa.4ac1f1c0@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbbbe0a028fa.4ac1f1c0@2ka.mipt.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Evgeny Polyakov wrote:
>
> I'm yet do download the latest git to check this particular patch, but
> I suppose it is possible to copy data under the lock into temporary
> buffer and then send it using existing infrastructure instead of
> calling it under the tasklist lock.

Afaics, we can just shift proc_sid_connector() from __set_special_pids()
to sys_setsid().

Oleg.

