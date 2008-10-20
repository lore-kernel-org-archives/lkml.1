Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbYJTJwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbYJTJwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYJTJwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:52:42 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:36290 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbYJTJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:52:42 -0400
Date: Mon, 20 Oct 2008 15:22:36 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint
	handler interfaces
Message-ID: <20081020095236.GA4042@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <787b0d920810200233v3ccc87bfjab4a4aec510a79cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920810200233v3ccc87bfjab4a4aec510a79cb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 05:33:40AM -0400, Albert Cahalan wrote:
> I'd just like to point out that not all hardware breakpoints
> involve addresses. For example:
> 
> The OLPC XO uses an x86 processor called the Geode.
> It supports a breakpoint that traps based on the opcode.
> For example, one could set it to trap on arpl instructions.

We should be able to handle such unique requirements by introducing a
new type of breakpoints (similar to HW_BREAKPOINT_EXECUTE,
HW)BREAKPOINT_WRITE, etc).

Thanks,
K.Prasad

