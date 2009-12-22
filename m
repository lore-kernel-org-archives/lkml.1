Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZLVLmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZLVLmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZLVLml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:42:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60616 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZLVLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s7rod3T5t0U+Pg0047B+W3F38YiV2Qz1IIMwWB1iBfsUIdNwldA3TSmfh0QQ3CkPTd
         RqnJd74L1U1X6brc3zyrMGv/C/zeSzqfgldpqOt8uvxZ189EgfL3lyY+vQhEep45fWl5
         4PdDA2TKq7uXXoBx8hdn1rUFrA1BbDxp5AR8k=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0912212020450.19919@dr-wily.mit.edu>
References: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>
	 <alpine.DEB.1.10.0912211926100.19919@dr-wily.mit.edu>
	 <2b41c200912211639p30927d84k9253ac7c90ac0e68@mail.gmail.com>
	 <alpine.DEB.1.10.0912211944050.19919@dr-wily.mit.edu>
	 <2b41c200912211710m11f1ebbbjc3d30c67e9e49944@mail.gmail.com>
	 <alpine.DEB.1.10.0912212020450.19919@dr-wily.mit.edu>
Date: Tue, 22 Dec 2009 12:42:35 +0100
Message-ID: <2b41c200912220342i5ceade4bjba94615238cd872d@mail.gmail.com>
Subject: Re: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/22, Tim Abbott <tabbott@ksplice.com>:
> Richard, can you test that this patch fixes the issue for you?

Using INIT_TEXT_SECTION(0) instead of INIT_TEXT_SECTION(PAGE_SIZE)
works fine here.
(Tested with 2.6.33-rc1 and 2.6.32)

//richard
