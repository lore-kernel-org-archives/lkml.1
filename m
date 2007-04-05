Return-Path: <linux-kernel-owner+w=401wt.eu-S1767320AbXDEVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767320AbXDEVXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767326AbXDEVXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:23:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767320AbXDEVXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:23:41 -0400
Date: Thu, 5 Apr 2007 14:22:03 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com, zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070405142203.bb2f0fb5.zaitcev@redhat.com>
In-Reply-To: <d120d5000704051354q61c5a6b4p9e8005152da4b42e@mail.gmail.com>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<20070402161225.2866c002.zaitcev@redhat.com>
	<Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
	<200704042324.56345.dtor@insightbb.com>
	<Pine.LNX.4.64.0704051049010.4173@jikos.suse.cz>
	<20070405133840.0d67303f.zaitcev@redhat.com>
	<d120d5000704051354q61c5a6b4p9e8005152da4b42e@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 16:54:17 -0400, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> > On a certain keyboard, when BIOS sets NumLock LED on, it survives the takeover
> > by Linux and thus confuses users.
> >
> > Eating of an increasibly scarce quirk bit is unfortunate. We do it for safety,
> > given the history of nervous input devices which crash if anything unusual
> > happens.

> You know, I would not call turning leds on an off an unusual operation
> for a keyboard.

Right, but monkeying with them immediately upon initialization may be
"unusual", meaning "device was tested with one version of Windows and
shipped, everything else is unusual".

-- Pete
