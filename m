Return-Path: <linux-kernel-owner+w=401wt.eu-S1762555AbXESFrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762555AbXESFrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXESFrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:47:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbXESFrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:47:02 -0400
Message-ID: <464E8ED7.6060607@redhat.com>
Date: Sat, 19 May 2007 13:44:55 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [2.6 patch] net/llc/llc_conn.c: fix possible NULL dereference
References: <464E8763.3010609@redhat.com> <20070518223005.91236c38.randy.dunlap@oracle.com>
In-Reply-To: <20070518223005.91236c38.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Randy Dunlap wrote:
> On Sat, 19 May 2007 13:13:07 +0800 Eugene Teo wrote:
> 
>> skb_peek() might return an empty list. skb should be checked before calling
>> llc_pdu_sn_hdr() with it.
>>
>> Spotted by the Coverity checker.
>>
>> Signed-off-by: Eugene Teo <eteo@redhat.com>
[...]
> 
> Networking patches need to be sent to the netdev@vger.kernel.org
> mailing list  (and lkml can be omitted IMHO).
> 
> But... instead of doing the assignment and test in one swoop,
> we prefer:

Right, thanks for the reminder!

Eugene
