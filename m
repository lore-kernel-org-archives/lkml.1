Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYCaLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYCaLtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYCaLtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:49:08 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:49725 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYCaLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:49:07 -0400
Message-ID: <47F0CFA6.1010105@cateee.net>
Date: Mon, 31 Mar 2008 13:48:54 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ben Castricum <lk08@bencastricum.nl>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [TRIVIAL PATCH] Microcode: show results on success too
References: <alpine.LNX.1.10.0803272041450.11972@gateway.bencastricum.nl> <20080328085958.GD21413@elte.hu>
In-Reply-To: <20080328085958.GD21413@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ben Castricum <lk08@bencastricum.nl> wrote:
> 
>> Report when microcode was successfully updated. It used to be there 
>> but now with DEBUG unset it becomes very silent. Also some cosmetic 
>> fixes.
> 
> thanks Ben, applied.

I think this part of the patch is not so good:
-	pr_debug("ucode data file %s load failed\n", name);
+	pr_debug("microcode: ucode data file %s load failed\n", name);

ucode is a short way for microcode, so you should remove "ucode" in
the new version

ciao
	cate
