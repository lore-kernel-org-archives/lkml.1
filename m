Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZJGLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZJGLWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbZJGLWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:22:48 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56384 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbZJGLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:22:47 -0400
From: Oliver Neukum <oliver@neukum.org>
To: admin@prnet.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.31.2 : error when ending apcupsd
Date: Wed, 7 Oct 2009 13:23:33 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <77ec4e85de9241d16244287e270a5244.squirrel@www.prnet.org>
In-Reply-To: <77ec4e85de9241d16244287e270a5244.squirrel@www.prnet.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071323.34819.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Oktober 2009 12:37:45 schrieb admin@prnet.org:
> Hi,
>
> With kernel 2.6.31.2 I get the following error when I ending apcupsd:
>
> Oct  6 21:00:46 server apcupsd[5238]: apcupsd exiting, signal 15
> Oct  6 21:00:46 server BUG: unable to handle kernel paging request at
> ffff880130a6d858
> Oct  6 21:00:46 server IP: [<ffffffff8124ba55>]
> tty_port_close_start+0xc5/0x1d0

This looks like tty_port_close_start() is called with port == NULL
And the new tty code went in with .2. I have to defer this to the Alans.

	Regards
		Oliver

