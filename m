Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYIKUmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYIKUmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYIKUlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:41:37 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43785 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYIKUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:41:36 -0400
Date: Thu, 11 Sep 2008 16:35:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: pull request: wireless-2.6 2008-09-11
Message-ID: <20080911203552.GL3423@tuxdriver.com>
References: <20080911201308.GJ3423@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911201308.GJ3423@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 04:13:08PM -0400, John W. Linville wrote:
> Dave,
> 
> Here is one fix for 2.6.27.  It is a backport of a patch that is already
> in net-next-2.6.  Since it is for a new driver (ath9k) and since it
> fixes a reported bug (http://bugzilla.kernel.org/show_bug.cgi?id=11394)
> I think it should be OK to pass it to Linus for the current cycle.
> 
> John

BTW, this (obviously) introduces a merge conflict between wireless-2.6 and wireless-next-2.6.  The solution is trivial -- just take the wireless-next-2.6 version of
the affected files.  Still, I have a sample merge available here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git merge-test

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
