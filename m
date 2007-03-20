Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbXCTHOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbXCTHOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXCTHOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:14:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:11314 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXCTHOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gmstGejW+KaTMT+1DDWXbsOpn8+JXOMoEzxYvT5Ty+qGssGmaGS5Q3P+fOjPwkmMrF5snVE6mGtuysA0axfSmh9aIzUJRARblHm3T+iDLiqREBbR9JTX4ZK+D4MLlukiTi61wUUT52LpFkBpBqhtDeNj8AE03ajHQkVQlQjIaCA=
Message-ID: <84144f020703200014j1ec8a6feq9828fd8739beff18@mail.gmail.com>
Date: Tue, 20 Mar 2007 09:14:51 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Cc: mpm@selenic.com, "Christoph Lameter" <clameter@sgi.com>,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070319144100.8a87f288.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319141038.212d4ac9.akpm@linux-foundation.org>
	 <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>
	 <20070319144100.8a87f288.akpm@linux-foundation.org>
X-Google-Sender-Auth: 4cd905986640722c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> This is a super-hot path.

Super-hot exactly where?
