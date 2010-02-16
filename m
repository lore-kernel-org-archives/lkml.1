Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0BPAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:09:58 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:36999 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab0BPAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wwi3la1njC68IFhYqLsrNSa4JJhIkhQUPjs+KEkQBkFUiW/WVXmYCHqIuhdzV/PW6t
         BimSW8/cDuCJL3MEtIN1PmscPz1CecApu01Kfh8eg402wAkL/zfzTx5iZEoH+HDxnlbF
         /2JHgoAvFXIypo264u85NWolrWEwyVDhX8hW4=
Message-ID: <4B79E251.3020005@lwfinger.net>
Date: Mon, 15 Feb 2010 18:09:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mb@bu3sch.de,
       davem@davemloft.net, stefano.brivio@polimi.it,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] ssb: open-code dma_alloc_coherent
References: <20100215142111R.fujita.tomonori@lab.ntt.co.jp>	<4B78EE6A.3010207@lwfinger.net> <20100215162426V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100215162426V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 01:25 AM, FUJITA Tomonori wrote:
> 2.6.33-rc8:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git pending
> 
> The ssb patch depends on the latest eight patches in the tree:
> 
> http://marc.info/?l=linux-kernel&m=126596737604808&w=2

The DMA changes work on i386 architecture with wireless devices in Cardbus (PCI)
format. Both b43legacy and b43 were tested.

Larry
