Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135Ab0AFTdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0AFTdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516Ab0AFTdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:33:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39956 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0AFTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:33:17 -0500
Date: Wed, 6 Jan 2010 20:33:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       xfs@oss.sgi.com, Artem Bityutskiy <dedekind@infradead.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100106193312.GB31857@basil.fritz.box>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com> <87eim4dbzw.fsf@basil.nowhere.org> <20100105122101.GR13802@discord.disaster> <20100105125234.GD1778@basil.fritz.box> <20100106172319.GA25046@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106172319.GA25046@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> lib-y doesn't work together with EXPORT_SYMBOL, having the export
> outside would also always pull it in.  These days the whole lib-y mess
> doesn't make sense anymore - if we really need an optional library
> symbol we can just pull it in through a Kconfig variable.

It works for non modular kernels with CONFIG_MODULES turned off.

See also the other patch I posted yesterday to fix this for 
lib/*

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
