Return-Path: <linux-kernel-owner+w=401wt.eu-S932538AbYEAXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbYEAXV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759158AbYEAXVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:21:18 -0400
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:65266 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759100AbYEAXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:21:18 -0400
Date: Thu, 1 May 2008 16:21:16 -0700
From: Tom Rini <trini@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       torvalds@linux-foundation.org, bunk@kernel.org, davem@davemloft.net,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501232116.GD4354@smtp.west.cox.net>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com> <20080501154238.eccdb6ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501154238.eccdb6ff.akpm@linux-foundation.org>
Organization: Embedded Alley Solutions, Inc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:42:38PM -0700, Andrew Morton wrote:

[snip]
> Is there some vaguely maintainable workaround we can do?  If the problem
> only affects completely-empty weak functions then we could put something in
> them to make them non-empty?

My memory is a tiny bit hazy (it was a while ago), but no, it's not just
empty functions (again, I _think_ I hit it with a generic vs arch weak
function).

-- 
Tom Rini
