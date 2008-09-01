Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYIAHCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYIAHCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYIAHCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:02:25 -0400
Received: from ozlabs.org ([203.10.76.45]:37916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYIAHCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:02:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Remove stop_machine during module load
Date: Mon, 1 Sep 2008 17:02:00 +1000
User-Agent: KMail/1.9.9
Cc: paulmck@us.ibm.com, linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20080829191734.GA28329@basil.nowhere.org>
In-Reply-To: <20080829191734.GA28329@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011702.00956.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 August 2008 05:17:34 Andi Kleen wrote:
> Remove stop_machine during module load
>
> module loading currently does a stop_machine on each module load to insert
> the module into the global module lists.  Especially on larger systems this
> can be quite expensive.

Thanks Andi, but doesn't this mean that we should be doing list_for_each_rcu 
in all the kallsyms readers?

Rusty.
