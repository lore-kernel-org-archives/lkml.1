Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbYLDTEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbYLDTEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYLDTEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:04:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758851AbYLDTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:04:01 -0500
Date: Thu, 4 Dec 2008 11:03:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Message-Id: <20081204110312.cd2a1be0.akpm@linux-foundation.org>
In-Reply-To: <1228416646.19553.117.camel@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	<20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
	<20081202132828.5c84b815.akpm@linux-foundation.org>
	<1228416646.19553.117.camel@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2008 18:50:46 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:

> Or, is there a way to tell whether it's in a kernel
> thread or user process context? Checking current->mm?

Yup, that'll work.  There might be small windows during process startup
and termination where a real process can have a NULL ->mm, but those
are probably benign in this case.

