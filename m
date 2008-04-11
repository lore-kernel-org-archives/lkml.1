Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYDKT4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYDKT4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbYDKTzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:55:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53408 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417AbYDKTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:55:52 -0400
Date: Fri, 11 Apr 2008 12:55:34 -0700
From: Greg KH <greg@kroah.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kdb@oss.sgi.com, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, nickpiggin@yahoo.com.au,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/2] add tunable_notifier function ,take2
Message-ID: <20080411195534.GA31401@kroah.com>
References: <47FF0EA5.8090804@ah.jp.nec.com> <47FF1910.1070001@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FF1910.1070001@ah.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 04:53:52PM +0900, Takenori Nagano wrote:
> This patch adds new notifier function tunable_notifier_chain. Its base is
> atomic_notifier_chain.

You are adding sysfs files, not debugfs files, please change your
announcement text.

Also, as you are adding new sysfs files, we need some documentation to
be added to Documentation/ABI/ describing what these files are, what are
in them, and how to use them.

thanks,

greg k-h
