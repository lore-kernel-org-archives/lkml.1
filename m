Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbXKGRwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbXKGRwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXKGRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:52:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:58113 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbXKGRwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hIu8xmmdvZUu8UABzZR+k/nXGM9NUlhlaSNOwkqhBhbUZE04y+WT6YzfIXyBHnyzH0BUyl2yFsQuoH4qnQ6eunFdq5f2XvR0+mkIIEFDuHOC2/fjISM1nccaD+MiBbQrH50G9GeM9mKaFe82HCn8vzeMfz086DXRgw8mdXZTf6o=
Message-ID: <8bd0f97a0711070952t614a655bpa2f1716d53bcf32d@mail.gmail.com>
Date: Wed, 7 Nov 2007 13:52:01 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>, "Bryan Wu" <Bryan.Wu@analog.com>
Subject: Re: [PATCH 1/2] Suppress A.OUT library support in ELF binfmt if !CONFIG_BINFMT_AOUT [try #3]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
In-Reply-To: <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
	 <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/07, David Howells <dhowells@redhat.com> wrote:
>  arch/blackfin/kernel/bfin_ksyms.c   |    1 -
>  arch/blackfin/kernel/process.c      |    7 +++++--
>  include/asm-blackfin/a.out.h        |    6 ------
>  include/asm-blackfin/processor.h    |    4 ++++

we're going to opt to simply delete any a.out related code for
Blackfin ... i think Bryan has patches in the queue to do just that
...
-mike
