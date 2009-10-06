Return-Path: <linux-kernel-owner+w=401wt.eu-S933398AbZJFVLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbZJFVLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZJFVLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:11:15 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34617 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZJFVLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:11:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] opticon: Fix resume logic
Date: Tue, 6 Oct 2009 23:12:17 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20091006145413.9431.47083.stgit@localhost.localdomain> <20091006150651.9431.16939.stgit@localhost.localdomain>
In-Reply-To: <20091006150651.9431.16939.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062312.17832.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 6. Oktober 2009 17:06:57 schrieb Alan Cox:
> Opticon now takes the right mutex to check the port status but the status
> check is done wrongly for the modern serial code, so fix it.

As Alan Stern noticed, it seems like we have an ab-ba deadlock here
between open and resume regarding pm_mutex and port->mutex.

	Regards
		Oliver

