Return-Path: <linux-kernel-owner+w=401wt.eu-S1750882AbXBVCvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbXBVCvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXBVCvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:51:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXBVCvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:51:48 -0500
Date: Wed, 21 Feb 2007 18:50:12 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: <vinctre@videotron.ca>, marcel@holtmann.org, vincent.fortier1@ec.gc.ca,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
Message-Id: <20070221185012.e4deeb68.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702200854520.25686@twin.jikos.cz>
References: <200702192111.47017.vinctre@videotron.ca>
	<Pine.LNX.4.64.0702200854520.25686@twin.jikos.cz>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 09:02:53 +0100 (CET), Jiri Kosina <jikos@jikos.cz> wrote:
> On Mon, 19 Feb 2007, Veronique & Vincent wrote:

> > Hi again Marcel and Jiri,
> > I've set up the hid-core.c to DEBUG mode... and it literally got pretty verbose...

> thanks for the output. Is this really the full output? The important part 
> - report descriptor dump - seems to be missing in the output (it should 
> read something like "hid-core.c: report descriptor (size XY, read YZ) = 
> ... some hexadecimal numbers". This should be output by the time the HID 
> device is connected.

Can I get something useful without a kernel recompile, with something
like evtest? I have users on Fedora hitting this too. It very likely is
a regression caused by the new unified HID.

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227598
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228755

-- Pete
