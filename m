Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbXECS57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbXECS57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXECS57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:57:59 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:49079 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbXECS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:57:58 -0400
Subject: Re: [patch] export hrtimer_forward
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <463A2296.7000804@aknet.ru>
References: <463A2296.7000804@aknet.ru>
Content-Type: text/plain
Date: Thu, 03 May 2007 20:57:54 +0200
Message-Id: <1178218674.24217.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 21:57 +0400, Stas Sergeev wrote:
> Hello.
> 
> It seems hrtimer_forward was forgotten to
> export - other symbols of the hrtimers API
> are already exported.
> Unless I am missing something, using the
> hrtimers without that function is problematic.
> 
> Andrew, could you please apply?

Are there actual in-tree users of this symbol? Without we usually leave
the symbol unexported, this saves some space.

