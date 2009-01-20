Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZATKRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZATKRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZATKRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:17:32 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:36376 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbZATKRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:17:31 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pavel Machek <pavel@suse.cz>
Subject: Re: lis3: fix documentation to fit into 80 columns
Date: Tue, 20 Jan 2009 11:18:03 +0100
User-Agent: KMail/1.9.10
Cc: Jiri Kosina <jkosina@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, eric.piel@tremplin-utc.net
References: <20090114172013.GA25948@elf.ucw.cz> <alpine.LNX.1.10.0901200027050.5377@jikos.suse.cz> <20090120101348.GI2576@elf.ucw.cz>
In-Reply-To: <20090120101348.GI2576@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901201118.05165.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 20 January 2009 11:13:49 schrieb Pavel Machek:
> > >  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
> > >  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> > > -calibrate - read: values (x, y, z) that are used as the base for input class device operation.
> > > -            write: forces the base to be recalibrated with the current position.

So you are computing a position according acceleration readings?
Isn't that common code to all accelerometers and should be put
into a higher level?

	Regards
		Oliver

