Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYLaAYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYLaAYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYLaAYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:24:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYLaAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:24:14 -0500
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm>
Date: Wed, 31 Dec 2008 01:25:48 +0100
In-Reply-To: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> (david@lang.hm's message of "Tue, 30 Dec 2008 14:21:10 -0800 (PST)")
Message-ID: <87k59hur5f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:
>
> doing a grep through System.map for the address that appears in the
> error returns nothing

This might be obvious, but you can't grep directly for these addresses
because System.map contains the starting addresses of functions only
and normally the reported address is somewhere in the middle of a 
function. So you instead have to look for the highest number lower or equal
the address from the exception.

-Andi

-- 
ak@linux.intel.com
