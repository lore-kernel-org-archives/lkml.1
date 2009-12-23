Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZLWBPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZLWBPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZLWBPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:15:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51793 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZLWBPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:15:00 -0500
To: "Smith, GeoffX" <geoffx.smith@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
From: Andi Kleen <andi@firstfloor.org>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
Date: Wed, 23 Dec 2009 02:14:51 +0100
In-Reply-To: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com> (GeoffX Smith's message of "Tue, 22 Dec 2009 16:33:19 -0800")
Message-ID: <87hbricwz8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Smith, GeoffX" <geoffx.smith@intel.com> writes:

> This patch fixes the semantics of prctl() option PR_MCE_KILL_GET 
> to pass the return value through *arg2.
>
> With this change, the option now follows the same conventions as the
> other "get" options added since 2.6.0, and also brings it into
> conformance with the advice in chapter 16 of Documentation/CodingStyle.
>
> This prctl() option was only added within the last month, so there are
> not any production applications to break.  This patch applies cleanly
> to mainline and to 2.6.32.2 for backporting.

It breaks the test suite, the man pages, qemu and one slide deck at least.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
