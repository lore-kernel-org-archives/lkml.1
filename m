Return-Path: <linux-kernel-owner+w=401wt.eu-S940188AbXGSRrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940188AbXGSRrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXGSRqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:46:54 -0400
Received: from web56614.mail.re3.yahoo.com ([66.196.97.58]:34741 "HELO
	web56614.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754928AbXGSRqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:46:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=a6HSTXKampaKyiKgLql+X92DapwTnvrwfN1bYl7O3L7RShmN8i98OQLh6MHVCGNAVnu7WD7ajwJV789XG8NI3qDseh4kmvh7/xYX7J4LLmjjDV85eqZoFB6Xp8+4rJBGb6HZIP4crCLs5pNSqlvZzoWjbNyCAK+7PYgZVgwmky8=;
X-YMail-OSG: uJUVB48VM1mIsviZ21GzKfRYJTRsJ77X6RtHUszpenQ7Gua4rx9cNK8_FpezxnnjphNoz5CmmUesit.U_gwG0R495m8nTo6YrVZSFkevcHbTRZIMMAD0xARySQ1bJADm.C_Hz_WMTfZMA1yK7U3_FBEgTQ--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.41.16
Date: Thu, 19 Jul 2007 10:46:52 -0700 (PDT)
From: andrei radulescu-banu <iubica2@yahoo.com>
Subject: Re: Linux, tcpdump and vlan
To: Patrick McHardy <kaber@trash.net>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <544527.16391.qm@web56614.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> [Andrei] VLAN_TX_SKB_CB() is perfect for that.
> [Patrick, Stephen] No its not. Its only legal to use while something has ownership
of the skb. Between VLAN devices and real devices qdiscs are
free to use it.

All right, using VLAN_TX_SKB_CB() is a bad idea. In that case, we need to amend the skb struct, I don't see another way.





       
____________________________________________________________________________________
Be a better Globetrotter. Get better travel answers from someone who knows. Yahoo! Answers - Check it out.
http://answers.yahoo.com/dir/?link=list&sid=396545469
