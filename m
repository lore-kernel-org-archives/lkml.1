Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbXJWRdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbXJWRdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXJWRdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:33:07 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:33268 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXJWRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:33:06 -0400
Date: Tue, 23 Oct 2007 18:32:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Roel Kluin <12o3l@tiscali.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Fix the baud_table check in encode_baud_rate
In-Reply-To: <471543C3.3050502@tiscali.nl>
Message-ID: <Pine.LNX.4.64N.0710231828180.8693@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
 <471543C3.3050502@tiscali.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Roel Kluin wrote:

> 		if (oclose >= abs(obaud - baud_table[i])) {
> 
> should work as well

 Hmm, I am not sure if it is clearer or produces better code, but send a 
patch -- I will not object.

  Maciej
