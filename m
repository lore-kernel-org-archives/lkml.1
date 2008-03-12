Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYCLPLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYCLPLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYCLPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:11:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49319 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751739AbYCLPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:11:07 -0400
Date: Wed, 12 Mar 2008 11:11:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Sven Schnelle <svens@stackframe.org>, <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data
In-Reply-To: <47D7E0D1.8050403@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0803121110320.4595-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Boaz Harrosh wrote:

> rrr only I cannot do that because the destructor does not have access to the us_data
> that contains it. As I said, very ugly. New patch attached.
> 
> Boaz
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Tue, 11 Mar 2008 20:30:53 +0200
> Subject: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data
> 
> if the inquiry fails then the info structure on
> us->extra was not freed.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

