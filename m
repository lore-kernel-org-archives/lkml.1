Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbXGXPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbXGXPqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXGXPqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:46:03 -0400
Received: from gw.goop.org ([64.81.55.164]:37858 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbXGXPqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:46:01 -0400
Message-ID: <46A61E85.6050605@goop.org>
Date: Tue, 24 Jul 2007 08:45:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       nix.or.die@googlemail.com, andi@firstfloor.org
Subject: Re: 2.6.22-git17 boot failure
References: <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A5D619.5030600@imap.cc> <20070724134516.GA2930@suse.de>
In-Reply-To: <20070724134516.GA2930@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> It seems the modules are not loaded at all in initrd, I dont see the
> 'SCSI subsystem initialized' message for example.

Yes.  It's not clear to me whether that's because module loading is
failing for some reason, or pci bus probing.  And completely unclear to
me why CONFIG_XEN should make a difference.

    J
