Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYC1QsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYC1QsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYC1QsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:48:06 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3391 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYC1QsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:48:05 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: tg3 bad performance, lots of hardware interrupts
From: "Michael Chan" <mchan@broadcom.com>
To: "Harald Hannelius" <harald@iki.fi>
cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0803281440460.23558@penti.org>
References: <alpine.DEB.1.00.0803271532570.30549@penti.org>
 <20080327.144925.196529669.davem@davemloft.net>
 <1206666100.5368.6.camel@dell>
 <alpine.DEB.1.00.0803281440460.23558@penti.org>
Date: Fri, 28 Mar 2008 09:49:20 -0800
Message-ID: <1206726560.6866.5.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6BF3FEBE60W18467764-05-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 15:04 +0200, Harald Hannelius wrote:
> Phew, I thought that running ethtool -t was like doing stop-A-sync on
> a 
> Sun. It took almost half an hour to run that ethtool -t command;

Something is very wrong.  ethtool -t should only take a few seconds to
complete.  You can try ethtool -t eth0 online to reduce the number of
tests to see if it makes a difference.

How many of these NICs do you have?  If you have more than one, do they
all behave the same way?  Have they ever worked well before?

