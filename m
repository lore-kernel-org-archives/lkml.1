Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYDAHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYDAHkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYDAHk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:40:29 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52174 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYDAHk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:40:29 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Date: Tue, 1 Apr 2008 09:38:53 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Sergey Dolgov <solkaa@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0803312143180.14330-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803312143180.14330-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804010938.53853.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
> Nevertheless, it's clear that the problem has nothing to do with the 
> USB stack.  The real source of the problem lies in the device itself, 
> for reporting a bogus error when in fact nothing went wrong.  That may 
> also explain why you don't always see the problem -- sometimes the 
> device works the way it ought to.

Reminds me of the devices that can read the last sector but only if it is read
by itself. Do you reckon this device may have the "opposite" quirk?

	Regards
		Oliver
