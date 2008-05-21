Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbYEUW0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbYEUW0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbYEUW0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:26:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54752 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbYEUW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:26:15 -0400
Subject: Re: [PATCH] USB: fix deadlock in HCD code
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       lchiquitto@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
Content-Type: text/plain
Date: Thu, 22 May 2008 00:26:08 +0200
Message-Id: <1211408768.29104.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 14:09 +0200, Jiri Kosina wrote:
> hcd_urb_list_lock is used for synchronization between IRQ and non-IRQ 
> contexts, so the non-IRQ context has to disable IRQs in order to prevent 
> deadlocking with IRQ context.

Just wondering,... doesn't lockdep say anything about the situation?

