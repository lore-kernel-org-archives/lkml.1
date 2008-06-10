Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYFJXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYFJXkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYFJXkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:40:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYFJXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:40:31 -0400
Message-ID: <484F0F5D.8010507@zytor.com>
Date: Tue, 10 Jun 2008 16:33:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in pat_init()
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl>
In-Reply-To: <484F065B.2050002@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> The current setup is okay really. The only thing it still wants is a 
> commandline whitelist switch but that needs a somewhat different setup 
> as validate_pat_support() is too early for __setup() or early_param().
> 

Actually, I think it's time to nuke the whitelist.  I don't think it has 
any CPUs on it that have the PAT flag enabled, still.

	-hpa
