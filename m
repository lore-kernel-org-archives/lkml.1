Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbYIJGxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbYIJGxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYIJGxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:53:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:7779 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYIJGxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BB1JrVN8fmWv70xm0jstz6uixdCNZchs+Cw9lCHELr8X3HTUpeU1hWoaIYg4wQtE79
         WqCORTU3fBElcOJPO8GcfOPQCudS70zVDidUqTu2hxSiuSks6bpYgr1jj3rrNotoxwHk
         UNlZJYwqQSgPMcdkpgiB5VKUIX4uGDDH7u5O8=
Message-ID: <2f11576a0809092353y1e25efeatebf1287d1b818560@mail.gmail.com>
Date: Wed, 10 Sep 2008 15:53:44 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
Cc: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>,
       "Mel Gorman" <mel@csn.ul.ie>, "Hugh Dickins" <hugh@veritas.com>,
       "William Irwin" <wli@holomorphy.com>, "Adam Litke" <agl@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       "Satoshi OSHIMA" <satoshi.oshima.fk@hitachi.com>
In-Reply-To: <20080910060431.188081541FE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080902134850.GA26372@csn.ul.ie> <48C48520.9070206@hitachi.com>
	 <20080910060431.188081541FE@magilla.localdomain>
X-Google-Sender-Auth: 51ae5dbbe35d3463
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It was certainly not meant to be excluded from any documentation.
>
> To make the description clear, MMF_DUMP_ELF_HEADERS applies when a
> file-backed private mapping would otherwise be elided (based on the other
> bits and whether it's been modified).  If the vma maps offset 0 of the
> file, and that page is readable and starts with ELFMAG, then just that
> first page will be dumped.  (So p_filesz will be PAGE_SIZE rather than 0
> for an elided mapping, or p_memsz for a mapping dumped whole.)

Could you please make the patch.
Then, I'll ack it with presure.

Thanks.
