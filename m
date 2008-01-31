Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbYAaSOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbYAaSOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765937AbYAaSOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:14:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765663AbYAaSOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:14:10 -0500
Subject: Re: OOM-killer invoked but why ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Claude Frantz <claude@pc0312b.rz.unibw-muenchen.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47A1DE20.5030305@pc0312b.rz.unibw-muenchen.de>
References: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
	 <1201790191.32654.7.camel@lappy>
	 <47A1DE20.5030305@pc0312b.rz.unibw-muenchen.de>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 19:14:15 +0100
Message-Id: <1201803255.32654.24.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 15:41 +0100, Claude Frantz wrote:
> Peter Zijlstra wrote:
> 
> > You seem to have ran out of zone normal memory with all of it stuck in
> > kernel allocations. Would you have /proc/slabinfo available?
> 
> Thanks Peter !
> 
> No ! There is no /proc/slabinfo available.

If you're using SLUB there is:
  Documentation/vm/slabinfo.c

