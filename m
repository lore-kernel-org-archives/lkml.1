Return-Path: <linux-kernel-owner+w=401wt.eu-S1761837AbYEOTv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761837AbYEOTv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758446AbYEOTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:50:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbYEOTuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:50:22 -0400
Date: Thu, 15 May 2008 15:42:59 -0400
From: Bill Nottingham <notting@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Problems with suspend and USB storage
Message-ID: <20080515194259.GA28848@nostromo.devel.redhat.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>
References: <20080515163315.GA17779@nostromo.devel.redhat.com> <200805152140.43292.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805152140.43292.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki (rjw@sisk.pl) said: 
> Well, the problem is that USB storage devices are disconnected during suspend
> and hibernation and connected once again during resume.  Then, however, we
> are not able to tell whether the device in the slot is the same that was in
> there before the system was put into the sleep state.

1) If they're disconnected, how come they work as a hibernate device? Or
   are they disconnected twice?
2) Isn't USB persist supposed to work around this?

Bill
