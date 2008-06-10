Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYFJPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYFJPCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYFJPCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:02:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49091 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYFJPCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:02:02 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
Date: Tue, 10 Jun 2008 17:01:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Roland Dreier <rolandd@cisco.com>, Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com> <adatzg15ol2.fsf@cisco.com>
In-Reply-To: <adatzg15ol2.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101701.47090.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 16:52:57 Roland Dreier wrote:
>  > During corner case testing, we noticed that some versions of ehca 
>  > do not properly transition to interrupt done in special load situations.
>  > This can be resolved by periodically triggering EOI through H_EOI, 
>  > if eqes are pending.
> 
> So just to be clear: this is a workaround for a hardware/firmware bug?
> 
>  - R.
> 

Yes it is.
regards Stefan
