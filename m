Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYIQQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYIQQK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYIQQKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:10:51 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:33616 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752922AbYIQQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:10:50 -0400
X-YMail-OSG: kICmYfsVM1kQScsMZpu1cyJuiYNTuv4KffygP6Rcck5bzyy6BYahQ..L31Q5DdW3NKEnfjxJo62zmTAuqrxF1eBL0NQzXxRmuT2iFiFxhkrCOpgGnWC5t05nYVu0774-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Wed, 17 Sep 2008 09:10:49 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Jim Rees <rees@umich.edu>
Cc: linux-nfs list <linux-nfs@vger.kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <766680.7905.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding back LKML.


----- Original Message ----
> From: Jim Rees <rees@umich.edu>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: linux-nfs list <linux-nfs@vger.kernel.org>
> Sent: Wednesday, September 17, 2008 5:31:12 PM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> Martin Knoblauch wrote:
> 
>    We never needed that in our case. But yes, would be trivial. The question
>    is, whether there should be a maximum, just as a safeguard.
> 
> Yes.  The default should be (RPC_DEF_SLOT_TABLE - 1), and the maximum should
> be max(xprt_udp_slot_table_entries, xprt_tcp_slot_table_entries) (maybe
> minus one).
> 

The default is NFS_MAX_READAHEAD, which is (RPC_DEF_SLOT_TABLE - 1). Incidentially, your suggested maximum seems to be the same on a default setup (minus one applied).

> I wonder if it would make sense to adjust NFS_MAX_READAHEAD when
> xprt_*_slot_table_entries is changed via sysctl.

I am not sure how useful/practical this is, as currently the ra_factor is applied at mount time.

Cheers
Martin

