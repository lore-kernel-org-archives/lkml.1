Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYBES7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYBES7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYBES7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:59:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbYBES73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:59:29 -0500
Date: Tue, 5 Feb 2008 10:59:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, michael.pyne@kdemail.net, AAbdulla@nvidia.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network
 card (regression in 2.6.23)
Message-Id: <20080205105909.fd8c6dbe.akpm@linux-foundation.org>
In-Reply-To: <47A8A90B.6010602@garzik.org>
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org>
	<47A8A90B.6010602@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 13:20:59 -0500 Jeff Garzik <jeff@garzik.org> wrote:

> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> NAK - this fixes one set of users, and breaks a working set of users.
> 
> Need to add DMI check for the specific motherboard (dmi_check_system), 
> and flip flag according to success/failure of that check.

OK :)  I added the above to the changelog for next time.

You guys can hide, but this patch isn't going away!
