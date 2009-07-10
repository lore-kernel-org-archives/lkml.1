Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZGJWt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZGJWt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZGJWtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:49:49 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36217 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbZGJWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:49:49 -0400
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak in request_firmware()
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
	<20090710173623.GA3687@kroah.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 10 Jul 2009 23:49:35 +0100
In-Reply-To: <20090710173623.GA3687@kroah.com> (Greg KH's message of "Fri\, 10 Jul 2009 10\:36\:23 -0700")
Message-ID: <tnxskh4nog0.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jul 2009 22:49:42.0922 (UTC) FILETIME=[B6FA76A0:01CA01B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote:
> On Tue, Jul 07, 2009 at 04:17:00PM +0100, Catalin Marinas wrote:
>> I get a couple kmemleak reports like below which I think happen on the
>> failure path (-ENOENT) of a request_firmware() call:
>
> Hm, can you send me the final version of this patch, it seemed to go
> through a few different versions, with a signed-off-by line?

It was merged as commit 0f2f2221b4ad8.

-- 
Catalin
