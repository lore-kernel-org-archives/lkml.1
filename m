Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXFCO3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXFCO3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXFCO3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:29:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37335 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbXFCO3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:29:45 -0400
Date: Sun, 3 Jun 2007 15:29:39 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070603142939.GW4095@ftp.linux.org.uk>
References: <20070603142450.GA4230@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603142450.GA4230@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 10:24:50PM +0800, WANG Cong wrote:
  
> +Do care when you use Lindent to indent your code, since it may use spaces
> +instead of tabs before a goto label and it may also align the label in a
> +wrong position. A goto label should be aligned in the column that is 8
> +characters ahead of the statement just below this label. Please fix it manually
> +if you find Lindent is wrong.

Lindent is wrong, but the style you are advocating is, at the very
least, not universal.  Equally (if not more) common is putting label
in column 1, period.  Regardless of indentation level of the statement
following it.
