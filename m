Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYGOT6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYGOT6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGOT6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:58:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYGOT6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:58:38 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150616.27455.377.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:57:46 -0700
Message-Id: <1216151866.26991.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 12:49 -0700, Linus Torvalds wrote:
> So kernel-specific directories do make sense. As does the whole "I
> don't want to handle the pain that is udev scripts".

I'm not violently opposed to kernel-specific directories. Ubuntu does it
that way already, and it may well make sense. I'm not sure it's really
necessary either, but it's an option.

Unless we really are going to make the kernel open files for itself,
though, I think it's too early for us to think about making that change
in the kernel. We'd need userspace to cope with it that way _first_.

(When I say 'in the kernel', I think the only place this 'policy' is yet
implemented is the default for $(INSTALL_FW_PATH) in modules_install and
firmware_install make targets, right?)

-- 
dwmw2

