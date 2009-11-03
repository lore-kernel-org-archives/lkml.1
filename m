Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbZKCTLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbZKCTLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZKCTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:11:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:33367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbZKCTLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:11:44 -0500
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
From: James Bottomley <James.Bottomley@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091103190420.GY10555@parisc-linux.org>
References: <1257273488.9427.27.camel@mulgrave.site>
	 <20091103105921.160d5599.akpm@linux-foundation.org>
	 <20091103190420.GY10555@parisc-linux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 13:11:42 -0600
Message-Id: <1257275502.2454.2.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 12:04 -0700, Matthew Wilcox wrote:
> static inline void strsrip_tail(char *str)
>  {
> -	char *x __used;
> -	x = strstrip(str);
> +	char *x = strstrip(str);
> +	BUG_ON(x != str);
>  }

Please, no.  I said didn't care about leading whitespace ... I didn't
say there wasn't any.

James


