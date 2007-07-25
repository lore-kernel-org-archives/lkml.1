Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbXGYLnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbXGYLnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbXGYLnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:43:09 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:38162 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109AbXGYLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:43:08 -0400
Message-ID: <46A736C9.4090701@gmail.com>
Date: Wed, 25 Jul 2007 13:40:57 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Valdis.Kletnieks@vt.edu, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com> <20070725113401.GA23341@elte.hu>
In-Reply-To: <20070725113401.GA23341@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 01:34 PM, Ingo Molnar wrote:

> and the fact is: updatedb discards a considerable portion of the cache 
> completely unnecessarily: on a reasonably complex box no way do all the 
> inodes and dentries fit into all of RAM, so we just trash everything.

Okay, but unless I've now managed to really quite horribly confuse myself, 
that wouldn't have anything to do with _swap_ prefetch would it?

Rene.
