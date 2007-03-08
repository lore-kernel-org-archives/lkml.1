Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXCHSiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXCHSiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCHSiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:38:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:57820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbXCHSiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:38:01 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jiang <djiang@mvista.com>
Subject: Re: [PATCH] x86_64 RESTORE_CONTEXT missing '\n'
Date: Thu, 8 Mar 2007 19:37:56 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, trini@kernel.crashing.org,
       sshtylyov@ru.mvista.com
References: <20070307204516.GA24095@blade.az.mvista.com> <200703081814.53153.ak@suse.de> <45F04B6E.9000703@mvista.com>
In-Reply-To: <45F04B6E.9000703@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081937.56167.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 18:44, Dave Jiang wrote:

> In spite of kgdb, shouldn't it have that \n anyways in case some other code
> gets added in the future after the macro? Or are you saying that there should
> never be any code ever after that macro?

Sure if there is mainline code added after that macro we add the \n.
But only if it makes sense to add code there, which it didn't in kgdb.

-Andi
