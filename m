Return-Path: <linux-kernel-owner+w=401wt.eu-S935410AbXJPTUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935410AbXJPTUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934505AbXJPTU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:20:26 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:46943 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934599AbXJPTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:20:25 -0400
Date: Tue, 16 Oct 2007 20:20:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <20071016192010.GA26692@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net> <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:14:32PM -0700, Linus Torvalds wrote:

> IOW, I think the thinkpad issue (and others like it) should be fixed by 
> splitting up the KEY_VOLUMEUP "key" into separate KEY_VOLUMEUP and 
> KEY_VOLUMEUP_NOTIFY key events, so that downstream user mode (and the 
> kernel itself, for that matter) can know whether it's a informational 
> message or whether it should be acted upon.

In principle I agree, but userspace already handles it. While it's 
certainly more correct, I'm not sure it provides any other real 
advantage.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
