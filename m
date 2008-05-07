Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYEGQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYEGQAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYEGQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:00:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48266 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348AbYEGQAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:00:19 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [ewg] [PATCH] IB/ehca: Protect QP against destroying until all async events for it are handled.
Date: Wed, 7 May 2008 18:00:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, fenkes@de.ibm.com,
       raisch@de.ibm.com
References: <200805071319.37164.ossrosch@linux.vnet.ibm.com> <adahcdaw2oc.fsf@cisco.com>
In-Reply-To: <adahcdaw2oc.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071800.15595.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2008 17:32:03 Roland Dreier wrote:
>  > We are not sure if this should be fixed in the driver or in uverbs itself.
>  > Roland, what's your opinion about this?
> 
> Would be nice to be able to fix it in uverbs but I don't see how.  In
> particular a kernel consumer has to have the same guarantee that no
> async events will come in after destroy QP returns.  And I don't see any
> way generic code can provide a guarantee about what low-level driver
> code may do internally.
> 

I agree, that's why I posted the driver fix first.
So, will you apply it next?

Regards Stefan

