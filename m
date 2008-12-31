Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYLaTgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYLaTgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYLaTgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:36:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50996 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYLaTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:36:41 -0500
Date: Wed, 31 Dec 2008 20:50:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081231195005.GT496@one.firstfloor.org>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231183039.GE20882@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> on the picture you sent me i noticed the message
> "Your memory is not aligned you need to rebuild your
> kernel with bigger NODEMAP SIZE shift=20" and then
> srat code complains about "No NUMA code hash function found"
> which looks a bit scary. Btw, could you post this picture
> on some public resource so NUMA people could check it?

This case used to be handled cleanly (NUMA disabled), but perhaps
that has regressed. But still it sounds like something is going wrong,
unless his machine really has a very weird memory map.

-Andi
-- 
ak@linux.intel.com
