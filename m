Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbXGXNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbXGXNpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761185AbXGXNpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:45:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:56857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623AbXGXNpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:45:18 -0400
Date: Tue, 24 Jul 2007 15:45:16 +0200
From: Olaf Hering <olh@suse.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       nix.or.die@googlemail.com, andi@firstfloor.org
Subject: Re: 2.6.22-git17 boot failure
Message-ID: <20070724134516.GA2930@suse.de>
References: <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A5D619.5030600@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46A5D619.5030600@imap.cc>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, Tilman Schmidt wrote:

> Netconsole logs with initcall_debug=1 of a successful and a
> failing startup and corresponding .config-s are available at
> http://www.phnxsoft.com/~ts/linux/

It seems the modules are not loaded at all in initrd, I dont see the
'SCSI subsystem initialized' message for example.
