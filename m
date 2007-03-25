Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXCYNyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXCYNyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 09:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXCYNyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 09:54:11 -0400
Received: from www17.your-server.de ([213.133.104.17]:3741 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXCYNyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 09:54:10 -0400
Message-ID: <46067F33.4030608@m3y3r.de>
Date: Sun, 25 Mar 2007 15:54:59 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>	<m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de>	<m1odmi4gx5.fsf@ebiederm.dsl.xmission.com> <46058B47.60204@m3y3r.de>	<m1fy7u3sas.fsf@ebiederm.dsl.xmission.com> <46065FED.8030206@m3y3r.de> <m11wjd4jiq.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11wjd4jiq.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
> Sounds possible.  You could probably verify it isn't my patch but running
> an unpatched kernel without msi support.  As I think the crash you saw should
> only be reproducible when using devices that support msi.
>   
Without your patch and with pci=nomsi option the same error occur. But i
think this is not an acpi error, because every interrupt seems to
trigger the shutdown, like moving the mouse, or pressing a key.
> Unless I hear different I'm going to assume that this second case is a
> completely different problem.  You might check to see if the acpi
> interrupt is stuck after a suspend/resume cycle.
>   
D'accord.
