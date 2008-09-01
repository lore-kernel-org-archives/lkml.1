Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYIAHJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYIAHJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYIAHJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:09:23 -0400
Received: from ozlabs.org ([203.10.76.45]:41615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYIAHJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:09:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Remove stop_machine during module load v2
Date: Mon, 1 Sep 2008 17:08:51 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, paulmck@us.ibm.com
References: <20080830080900.GA19870@basil.nowhere.org>
In-Reply-To: <20080830080900.GA19870@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011708.52914.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 August 2008 18:09:00 Andi Kleen wrote:
> Remove stop_machine during module load v2
>
> module loading currently does a stop_machine on each module load to insert
> the module into the global module lists.  Especially on larger systems this
> can be quite expensive.
>
> It does that to handle concurrent lock lessmodule list readers
> like kallsyms.

Thanks, Andi!

Applied,
Rusty.
