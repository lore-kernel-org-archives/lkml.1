Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYFXTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYFXTe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYFXTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:34:18 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:45480 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYFXTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:34:18 -0400
Date: Tue, 24 Jun 2008 23:34:22 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: Fix percpu for !SMP
Message-ID: <20080624193422.GA8949@jurassic.park.msu.ru>
References: <59ea9d21fca74a2e8ffec8384815d7c54c8b4a5c.1214324538.git.segher@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ea9d21fca74a2e8ffec8384815d7c54c8b4a5c.1214324538.git.segher@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 06:25:12PM +0200, Segher Boessenkool wrote:
> Commit 9267b4b3880d00dc2dab90f1d817c856939114f7 introduced a
> percpu.h for alpha.  It didn't define PER_CPU_ATTRIBUTES for
> the non-SMP case, leading to build failures for such a config
> (e.g., the alpha defconfig).

Thanks, but similar patch from Thorsten Kranzkowski already
went in.

Ivan.
