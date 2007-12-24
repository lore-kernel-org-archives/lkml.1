Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbXLWXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbXLWXjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXLWXjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:39:05 -0500
Received: from smtp25.orange.fr ([193.252.22.23]:37420 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXLWXjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:39:02 -0500
X-ME-UUID: 20071223233856256.3E8921C00084@mwinf2509.orange.fr
Message-ID: <476F0ED5.3090609@free.fr>
Date: Mon, 24 Dec 2007 02:43:49 +0100
From: Stephane Ascoet <stephaneascoet@free.fr>
Organization: Conseils pour que le progres profite a tous les terriens
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx,
       linux-acpi@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Li Shaohua <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: do not stop/start devices in suspend/resume path: the SCSI case
References: <4745F77C.7040402@gmail.com> <47511751.2010707@gmail.com> <47514CE2.3000600@gmail.com> <200712051124.18852.bjorn.helgaas@hp.com>
In-Reply-To: <200712051124.18852.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas a écrit :
> Good.  It's not clear to me whether it is safe to leave devices
> enabled while we sleep.  I don't see an actual problem, but there
> might be something related to hotplug while we're asleep or something.
> So I'll cc: some additional people who might have some insight.
Hi, is there a chance for SCSI sleeping being managed by ACPI(it seems 
to be the case for IDE)?

-- 
Bien cordialement, Stephane Ascoet, conseils pour que la technologie 
soit un progres respectueux de la vie.
Album photo:<http://www.flickr.com/photos/stephaneascoet/>
