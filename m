Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYH1O7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYH1O7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYH1O7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:59:08 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:3701 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYH1O7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qg9b3T8os2j+xL/IcWwPMNMpfaP+1RRJSc2nAOBFxmsF9oMpso4dQHFGUBr9yYvgHL
         Js8o5vcj9dXWct8Xcbl3bAVguaaAU03jKjccwqcm+p+oH1ipbtGs3aOryWl1q6Y42BfA
         TJ8htl/Lx31qD1BgeNx8w64rNFBRpon3yhjgA=
Message-ID: <2f11576a0808280759k2500f2ebm89ab9c3601014457@mail.gmail.com>
Date: Thu, 28 Aug 2008 23:59:05 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adam Litke" <agl@us.ibm.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
Cc: "Kawai Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       "Hugh Dickins" <hugh@veritas.com>, "William Irwin" <wli@holomorphy.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1219934895.14358.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1219934895.14358.40.camel@localhost.localdomain>
X-Google-Sender-Auth: 7a85d224b0ee099e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have tested this using both the provided C program and with a program
> that used libhugetlbfs to back its text and data segments with huge
> pages.  This seems to work as expected.  From a hugetlbfs perspective,
> this seems like a reasonable patch to me.

Thank you, Adam!

Yes, libhugetlbfs user increased in these days.
So, I believe debaggability of libhugetlbfs linked program is important.

>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> CC: Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com>
>> CC: Hugh Dickins <hugh@veritas.com>
>> CC: William Irwin <wli@holomorphy.com>
>> CC: Adam Litke <agl@us.ibm.com>
>
> Tested-by: Adam Litke <agl@us.ibm.com>
> Acked-by: Adam Litke <agl@us.ibm.com>
>
