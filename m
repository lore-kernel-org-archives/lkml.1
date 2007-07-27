Return-Path: <linux-kernel-owner+w=401wt.eu-S932613AbXG0IKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbXG0IKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXG0IJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:09:22 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:60855 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXG0IJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:09:18 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] usb-storage autosuspend bug?
Date: Fri, 27 Jul 2007 10:11:07 +0200
User-Agent: KMail/1.9.7
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070720034456.GA5826@kroah.com> <alpine.LFD.0.999.0707251628200.3607@woody.linux-foundation.org> <20070726155746.GA5493@suse.de>
In-Reply-To: <20070726155746.GA5493@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271011.07471.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 26 Juli 2007 schrieb Greg KH:
> Alan and Oliver, was this caused by the autosuspend changes for
> usb-storage?

The oops itself looks like refcounting. What caused the initial io error
does not become clear from the log. It is possible that the device cannot
stand suspension. But there's no evidence from that. On the contrary,
these devices usually do an unplug/plug cycle, which is not in the log.

	Regards
		Oliver

