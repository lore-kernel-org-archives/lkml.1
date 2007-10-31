Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXJaEd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXJaEd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXJaEdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:33:17 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:48342 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751216AbXJaEdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:33:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fbYv4pM1Nod+XJFn5o24hZ07b5emxfoYQwmNVGbMG8ok+2VtthHGop2Gs6xfnTF6q7sjyYmvVkJi5HPegoEtR3K+1k2/7DjOuR48Bo+Ak0/KBDW9QStMiszwGLB+rwdfSjdJWbYD3W3eZez2F7ZPW9SYgCCpw3EWnbdILyf8kyM=  ;
X-YMail-OSG: QSNV5eoVM1mv1I7A7f.oX342.GESpVlGwpTD7P7TxhmNmc9gOQjHZNjKGQbY2RwkpS0Wfbvn0g--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/33] Swap over NFS -v14
Date: Wed, 31 Oct 2007 14:26:32 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl>
In-Reply-To: <20071030160401.296770000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311426.33223.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> Hi,
>
> Another posting of the full swap over NFS series.

Hi,

Is it really worth all the added complexity of making swap
over NFS files work, given that you could use a network block
device instead?

Also, have you ensured that page_file_index, page_file_mapping
and page_offset are only ever used on anonymous pages when the
page is locked? (otherwise PageSwapCache could change)
