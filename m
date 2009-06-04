Return-Path: <linux-kernel-owner+w=401wt.eu-S1752396AbZFDM7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbZFDM7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZFDM7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:59:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38054 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZFDM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:59:33 -0400
Date: Thu, 4 Jun 2009 13:53:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
Message-ID: <20090604125306.GC24491@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244118476.5172.29.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> fix the following 'make headers_check' warning:

I think headers_check needs fixing - there's nothing wrong with the
code as it presently stands except the tools obviously can't properly
parse C preprocessor statements.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
