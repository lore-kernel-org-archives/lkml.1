Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbXJELnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbXJELnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXJELnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:43:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:25364 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXJELnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q/ClousCiLLnNHUo5fsvl6ralkEz/1yJZpDXlAVl8bK2n9FwJz14g7WtqTkwaVrG+YAZQeSqkUtxOQ9pneQ0RSm1CzubChDpjVT6TnZdyAHCNhdjQ66ireMETDzk9MyxjFfBNqSJwWbo+0iMnnkFQDwaoNJK7kZm2Q2oo91kYrg=
Message-ID: <68676e00710050443j2f721fe7s77833de3652a3ca3@mail.gmail.com>
Date: Fri, 5 Oct 2007 13:43:04 +0200
From: Luca <kronos.it@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: [PATCH for testing] Re: Decreasing stime running confuses top
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Frans Pop" <elendil@planet.nl>, "Willy Tarreau" <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       "Alexander E. Patrakov" <patrakov@ums.usu.ru>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <470562B9.6060200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710031433.34504.elendil@planet.nl>
	 <200710042200.03489.borntraeger@de.ibm.com>
	 <47054B2E.1050906@redhat.com>
	 <200710042310.25223.borntraeger@de.ibm.com>
	 <470562B9.6060200@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Chuck Ebbert <cebbert@redhat.com> wrote:
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

Works fine here.

>
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Tested-By: Luca Tettamanti <kronos.it@gmail.com>

Luca
