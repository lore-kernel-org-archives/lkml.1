Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbXJDWb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbXJDWb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXJDWbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:31:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:21427 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXJDWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:31:21 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
Date: Fri, 5 Oct 2007 00:31:16 +0200
User-Agent: KMail/1.9.7
Cc: Luca Tettamanti <kronos.it@gmail.com>, Frans Pop <elendil@planet.nl>,
       Willy Tarreau <w@1wt.eu>, LKML <linux-kernel@vger.kernel.org>,
       Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       Ingo Molnar <mingo@elte.hu>
References: <200710031433.34504.elendil@planet.nl> <200710042310.25223.borntraeger@de.ibm.com> <470562B9.6060200@redhat.com>
In-Reply-To: <470562B9.6060200@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710050031.16275.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. Oktober 2007 schrieb Chuck Ebbert:
> On 10/04/2007 05:10 PM, Christian Borntraeger wrote:
> 
> > <patch reverting to 2.6.22 behavior>
> 
> Alternative patch:
> 
> procfs: Don't read runtime twice when computing task's stime
> 
> Current code reads p->se.sum_exec_runtime twice and goes through
> multiple type conversions to calculate stime. Read it once and
> skip some of the conversions.
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Looks better and makes the code nicer. s390 and power should work as well as 
CONFIG_VIRT_CPU_ACCOUNTING is unaffected. 

If Frans successfully tests this patch, feel free to add

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Christian
