Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZBVMqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZBVMqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZBVMqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:46:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33612 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZBVMqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:46:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A148F7.1010302@s5r6.in-berlin.de>
Date: Sun, 22 Feb 2009 13:45:43 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: Ingo Molnar <mingo@elte.hu>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init/main.c: fix sparse warnings: context imbalance
References: <20090221194940.12602.54077.stgit@vmbox.hanneseder.net>	 <49A13765.5070902@s5r6.in-berlin.de> <154e089b0902220336m2aeebc56p6f2af57118463352@mail.gmail.com> <49A1477B.7080206@s5r6.in-berlin.de>
In-Reply-To: <49A1477B.7080206@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Hannes Eder wrote:
>> On Sun, Feb 22, 2009 at 12:30 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> It is not a fix, it's merely an annotation.
>> This patch 'better word for fix's a warning reported by sparse. What
>> better wording would you suggest?
> 
> "annotate init_post() as releasing the BKL" or whatever in the title,
> furthermore "Removes the following sparse warnings: ..." in the changelog.

PS:  In some sense it is indeed a "fix" for the high-level problem that
sparse can't guess whether the context imbalance is correct or not.  The
original warning from sparse was correct in itself.  Your annotation
enables sparse to warn if problems outside the scope of the single
function occur (I guess).  So it's more a maintainabiliy improvement
than a fix.
-- 
Stefan Richter
-=====-==--= --=- =-==-
http://arcgraph.de/sr/
