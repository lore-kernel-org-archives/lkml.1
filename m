Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbYEUNVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbYEUNVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764002AbYEUNVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:21:14 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:53399 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762314AbYEUNVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:21:13 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
Date: Wed, 21 May 2008 15:21:00 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805211521.01435.oliver@neukum.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 14:09:43 schrieb Jiri Kosina:
> hcd_urb_list_lock is used for synchronization between IRQ and non-IRQ 
> contexts, so the non-IRQ context has to disable IRQs in order to prevent 
> deadlocking with IRQ context.

Which non-irq context is that?

	Regards
		Oliver
