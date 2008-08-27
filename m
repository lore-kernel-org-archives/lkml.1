Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYH0VDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYH0VDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYH0VD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:03:26 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:41217 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYH0VD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:03:26 -0400
Date: Wed, 27 Aug 2008 17:03:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is SKAS still required for UML
Message-ID: <20080827210319.GA14123@c2.user-mode-linux.org>
References: <alpine.LNX.1.10.0808271251170.1378@fbirervta.pbzchgretzou.qr> <20080827190655.GB12522@c2.user-mode-linux.org> <alpine.LNX.1.10.0808271551270.1378@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808271551270.1378@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 04:00:24PM -0400, Jan Engelhardt wrote:
> In tests of mine, oggenc in SKAS0 mode ran at 95% of native speed, which 
> is pretty good.

Different workloads give different results.  Yours sounds
CPU-intensive.  Kernel builds here run at 50-60% of native with skas0,
low 80's with skas3, and ~86% with skas4.

    	      	     	 Jeff

-- 
Work email - jdike at linux dot intel dot com
