Return-Path: <linux-kernel-owner+w=401wt.eu-S967549AbXFHDil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967549AbXFHDil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966629AbXFHDid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:38:33 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966457AbXFHDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:38:32 -0400
Message-ID: <4668CF2E.8000707@zytor.com>
Date: Thu, 07 Jun 2007 20:38:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Lord <lkml@rtr.ca>, Andi Kleen <ak@suse.de>
Subject: Re: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
References: <20070608023551.GJ15426@holomorphy.com> <20070607194156.d4aacf4c.akpm@linux-foundation.org> <20070608030629.GW6909@holomorphy.com>
In-Reply-To: <20070608030629.GW6909@holomorphy.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> 
> !CONFIG_X86_PAE && CONFIG_HIGHMEM64G doesn't make sense and is not allowed
> by this patch. CONFIG_X86_PAE && !CONFIG_HIGHMEM64G works here.
> 

But what's the point?

If you're going to divorce these, at least do it in a way that makes
sense, specifically the two independent variables are PAE and HIGHMEM.
PAE and !HIGHMEM does make (some amount of) sense, due to no kmap overhead.

	-hpa
