Return-Path: <linux-kernel-owner+w=401wt.eu-S965098AbXAYXeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098AbXAYXeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXAYXeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:34:19 -0500
Received: from twin.jikos.cz ([213.151.79.26]:39786 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965098AbXAYXeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:34:18 -0500
Date: Fri, 26 Jan 2007 00:33:13 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: mirek kratochvil <exa.exa@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Problems on x86_64 laptops (high-load crashes?)
In-Reply-To: <a37929f0701251506i2778aed2v80e8742dcb3ad10e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701260029090.1889@twin.jikos.cz>
References: <a37929f0701251506i2778aed2v80e8742dcb3ad10e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, mirek kratochvil wrote:

> I want to ask about strange behavior of linux kernel on some laptops 
> (namely recent Asus laptops with dualcore 64bit Athlons). There's a 
> weird bug when the kernel's under some kind of heavy load. It usually 
> freezes all processes which run from X11 (including X11..) - happens 
> usually when:
[ .. snip .. ]
> about hardware - this is mostly seen on Asus A6 and similar laptops. 
> A6T, A6Tc, A6Km,....

What BIOS do the machines have? 04xx versions are known to be horribly 
buggy (even the-other-OS(tm) users experience strange things).

In case you have BIOS 04.., try to upgrade to 06.. version. Also, does it 
help when you boot with acpi=off kernel commandline parameter? (do you 
compile kernel with both acpi and apic support?).

-- 
Jiri Kosina
