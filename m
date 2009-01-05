Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZAEJ46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZAEJ46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZAEJ4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:56:49 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:51304 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZAEJ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:56:48 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Daryl Radivojevic" <daryl.rad@gmail.com>
Subject: Re: OOPS report
Date: Mon, 5 Jan 2009 11:04:07 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "linux-usb" <linux-usb@vger.kernel.org>
References: <dd0bb5c00901020042w6b44e17fu3a4bb46cc4ff7b2e@mail.gmail.com>
In-Reply-To: <dd0bb5c00901020042w6b44e17fu3a4bb46cc4ff7b2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051104.08352.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 2. Januar 2009 09:42:43 schrieb Daryl Radivojevic:
> Here is an OOPS report. This happens frequently. Mainly if I start
> wvdial from xterm, and then quit X-Windows.

Please use a more descriptive subject next time.

> ------------[ cut here ]------------
> WARNING: at drivers/usb/serial/usb-serial.c:326

This means that usb-serial thinks your device is closed yet somebody
uses it. Quitting X explains the closure part. Please replicate with "debug=1"
as a module parameter for usb-serial and post dmesg.

	Regards
		Oliver
