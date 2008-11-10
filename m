Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYKJBMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYKJBMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 20:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYKJBMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 20:12:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:34161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYKJBMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 20:12:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,571,1220252400"; 
   d="scan'208";a="358082454"
Subject: Re: BUG: scheduling while atomic: iwl3945/0/3680/0x00000002 during
	resume from suspend
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <49172112.60508@gmail.com>
References: <20081109141412.GA5858@dhcp35.suse.cz>
	 <49172112.60508@gmail.com>
Content-Type: text/plain
Organization: Intel Corp.
Date: Mon, 10 Nov 2008 09:12:20 +0800
Message-Id: <1226279540.2604.277.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 01:42 +0800, Jiri Slaby wrote:
> I think the same as:
> http://marc.info/?l=linux-wireless&m=122254514501379&w=2

Yup. Try this fix.
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=605b6cd038c5002f8dcbd3695aa934a130257af4

Thanks,
-yi

