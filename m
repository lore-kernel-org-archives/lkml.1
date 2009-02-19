Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZBSSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZBSSoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZBSSoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:44:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBSSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:44:07 -0500
Message-ID: <499DA7AB.8080000@zytor.com>
Date: Thu, 19 Feb 2009 10:40:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
References: <1235068713.15053.99.camel@nathan.suse.cz>
In-Reply-To: <1235068713.15053.99.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> Since __builtin_trap() will always generate an illegal instruction, we
> can replace the explicit asm("ud2") with it.
> 
> This way gcc will understand that the function never returns, plus it
> won't emit any extra instructions.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

I like this.  Will apply shortly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

