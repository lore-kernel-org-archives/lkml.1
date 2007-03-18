Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXCRMnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXCRMnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 08:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXCRMnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 08:43:16 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:16417 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbXCRMnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 08:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DoIx8+SKQ9t6tnujl/W1Oj7oU94+CHdk3obdPZm9+DRkDt50no+8dDf41jhztKcNWV8IYP+WiY3fq5WTmklh6WOMWmeQsTWqRlNCMiXw4bDlqEu4pqCzoqZXCfnYO9o38qkoQOq3A6y1oaUb5iRQbkjGHG8+qOy/P/mf1qle8ZI=
Message-ID: <bd87e7590703180543p75c46b8fk44a0df061d21a17@mail.gmail.com>
Date: Sun, 18 Mar 2007 13:43:13 +0100
From: "Kevin Baradon" <kevin.baradon@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re : [2.6.21-rc{3,4} problem]: missing dependency on NF_NAT
Cc: linux-kernel@vger.kernel.org,
       "Netfilter Development Mailinglist" 
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: <45FC0226.2010305@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <bd87e7590703170738q2363274fx120630d5d4e3279@mail.gmail.com>
	 <45FC0226.2010305@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/17, Patrick McHardy <kaber@trash.net>:
> Kevin Baradon wrote:
> > Compiling kernel 2.6.21-rc3 gives me the following errors :
> >
> >  LD      .tmp_vmlinux1
> > net/built-in.o: dans la fonction « nfnetlink_parse_nat_proto »:
> > nf_conntrack_netlink.c:(.text+0x28db9): référence indéfinie vers «
> > nf_nat_proto_find_get »
> > [...]
> >
> > Also occurs with 2.6.21-rc4.
> > Setting CONFIG_NF_NAT to 'y' fixes problem.
>
>
> Thanks, I queued this patch, which should fix it.

Yes, it works for me.
Thanks.

>
