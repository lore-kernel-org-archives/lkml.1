Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbXBETjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbXBETjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbXBETjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:39:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44318 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbXBETjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:39:20 -0500
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
From: Arjan van de Ven <arjan@infradead.org>
To: casey@schaufler-ca.com
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, agruen@suse.de
In-Reply-To: <101270.11571.qm@web36602.mail.mud.yahoo.com>
References: <101270.11571.qm@web36602.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 05 Feb 2007 20:39:08 +0100
Message-Id: <1170704348.3107.61.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Would it be possible for you to describe those
> methods? Perhaps there is a better way to go
> about getting the information you need without
> introducing this level of change.

the code did a full walk of the vfsmounts to find a match. Entirely
horrid!

There is no problem with such a medium-severity level change as long as
it's the right thing... in Linux we mostly try to solve problems the
right way rather than adding workarounds on both sides of an interface
after all ;-)


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

