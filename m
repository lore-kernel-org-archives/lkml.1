Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbZJGUze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbZJGUze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbZJGUzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:55:33 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:60176 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZJGUzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:55:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Date: Wed, 7 Oct 2009 22:56:20 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910071434290.3051-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910071434290.3051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910072256.21316.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Oktober 2009 20:52:21 schrieb Alan Stern:
> However in the option and sierra drivers there is a perverse path from
> close to resume: Both their close methods call
> usb_autopm_get_interface().  This could be removed without much
> trouble; perhaps we should do so.

I am afraid this won't do in the long run. Some drivers will want to
shut down devices by communicating with them in close().

	Regards
		Oliver

