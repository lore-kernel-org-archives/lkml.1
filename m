Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYFJWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYFJWQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYFJWQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:16:32 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:50538 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYFJWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:16:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Date: Wed, 11 Jun 2008 00:15:58 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com> <200806101650.27180.mb@bu3sch.de> <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
In-Reply-To: <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110015.59285.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 00:09:27 Miles Lane wrote:
> I got a slightly different BUG with this patch applied:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<f89e3d41>] :b43:b43_dma_mapping_error+0x16/0x97

So can you please debug this? This is trivial. Just add a few printks
to see which pointer is NULL.
As I said I don't have this tree and really like to avoid fetching
and building yet another tree.

-- 
Greetings Michael.
