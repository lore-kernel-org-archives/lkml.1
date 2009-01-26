Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZAZIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZAZIfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZAZIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:35:35 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:55760 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZAZIfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:35:34 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: System hang (and other problems) with cdc_acm
Date: Mon, 26 Jan 2009 09:36:00 +0100
User-Agent: KMail/1.9.10
Cc: "Thomas Tuttle" <linux-kernel@ttuttle.net>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com> <20090125232753.db40c160.akpm@linux-foundation.org>
In-Reply-To: <20090125232753.db40c160.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901260936.01501.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 26 January 2009 08:27:53 schrieb Andrew Morton:
> > I've got a Lenovo X200 with an Ericsson F3507g Mobile Broadband Module
> > (a 3G cellular data card with built-in GPS), which uses the cdc_acm
> > driver.  I've experienced a couple of problems with it.  First, it
> > tends to hang the system after I've been using it for a while.  This
> > occurs whenever it's sending a lot of data to/from the computer,
> > whether it's a PPP connection or a GPS data stream.  I'm not sure how
> > to debug this; the Caps Lock light isn't flashing, so I'm not sure if
> > it's a panic or just a hang.  Second, if I read one of the TTYs using
> > "cat", I get a ton of blank lines.  To make any sense of the data
> > stream, I have to do cat /dev/ttyACM0 | grep -v "^$".
> > 
> > If anyone could help me debug this, I'd be greatly appreciative.

It is probably necessary to setup a watchdog. Can you do that?
As for the blank lines, I am not sure this is a bug. Your device may
indeed send a lot of newlines.

	Regards
		Oliver

