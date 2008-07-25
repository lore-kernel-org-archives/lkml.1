Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYGYSYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYGYSYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYGYSXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:23:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:15110 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYGYSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tWAZpUGV2heXh2WN6X2bciM7nJzUDruMWI+0IR9wPY7h0qkMQ98whl/pMx7HOdnrKV
         Hk9tHLFGy8q+D8rJzQV8cgNruk6//D839U2qscPxC5X8Yq/AaZRZY7lhLnmFnRL4GIDL
         I+K/zLYrxIsyUrqg9Cnhop5WYgdpt8Dk8Z2Vg=
Message-ID: <29495f1d0807251123j44ff95f5q3a84616d8bdffdf0@mail.gmail.com>
Date: Fri, 25 Jul 2008 11:23:52 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: cpuset build error: cpuset_mems_nr() missing
Cc: pj@sgi.com, menage@google.com, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080725112146.1cf70319.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725112146.1cf70319.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>  When SYSCTL=n, PROC_FS=n:
>
>  linux-next-20080725/mm/hugetlb.c:1507: error: implicit declaration of function 'cpuset_mems_nr'
>  make[2]: *** [mm/hugetlb.o] Error 1
>
>
>  Alan mentioned this in another mail thread and I believe he said that the problem
>  is also in mainline... but I haven't checked that.

Fix posted a little while ago:
http://marc.info/?l=linux-kernel&m=121700986003238&w=2

Thanks,
Nish
