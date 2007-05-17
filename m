Return-Path: <linux-kernel-owner+w=401wt.eu-S1762482AbXEQVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762482AbXEQVx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXEQVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:53:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbXEQVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:53:18 -0400
Date: Thu, 17 May 2007 17:52:00 -0400
From: Dave Jones <davej@redhat.com>
To: Ed Sweetman <safemode2@comcast.net>
Cc: Len Brown <lenb@kernel.org>, Daniel Drake <dsd@gentoo.org>,
       duaneg@dghda.com, prakash@punnoor.de, jhoblitt@ifa.hawaii.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-ID: <20070517215200.GD398@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ed Sweetman <safemode2@comcast.net>, Len Brown <lenb@kernel.org>,
	Daniel Drake <dsd@gentoo.org>, duaneg@dghda.com, prakash@punnoor.de,
	jhoblitt@ifa.hawaii.edu, linux-kernel@vger.kernel.org
References: <20070516235050.9B4237B409F@zog.reactivated.net> <200705171413.42595.lenb@kernel.org> <20070517182340.GA25691@redhat.com> <464CC920.6030409@comcast.net> <464CCBCF.3010001@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464CCBCF.3010001@comcast.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:40:31PM -0400, Ed Sweetman wrote:

 > Here's a patch

(please inline patches so they can be quoted in replies).

having this as a tristate makes no sense, that code can't be modular.
Also, there's a gratuitous whitespace change, and the default should
probably stay.

If there's consensus we should make this a user-visible option,
we can do that, though I still don't think this is any more
perfect than the other option that Daniel posted.

	Dave

-- 
http://www.codemonkey.org.uk
