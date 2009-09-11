Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZIKTdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZIKTdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZIKTdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:33:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40071 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZIKTdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:33:44 -0400
Date: Fri, 11 Sep 2009 21:33:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andi Kleen <andi@firstfloor.org>, npiggin@suse.de, riel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/21] HWPOISON: The high level memory error handler
	in the VM v7
Message-ID: <20090911193346.GE32562@basil.fritz.box>
References: <20090911848.933193846@firstfloor.org> <20090911184845.38A6EB1758@basil.firstfloor.org> <1252697149.28368.12.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252697149.28368.12.camel@desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The rest of your patches are totally clean, except this one .. It has
> some warning, but one error in the second ifdef block above ..

That's intentional, fixing it would require a bare , on a single line
which would be far uglier what is there today. I refuse to make code
ugly just to work around checkpatch.pl

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
