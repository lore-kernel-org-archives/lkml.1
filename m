Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbZBMTeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbZBMTeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZBMTeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:34:11 -0500
Received: from www.tglx.de ([62.245.132.106]:59961 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbZBMTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:34:10 -0500
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 2/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<alpine.LSU.2.00.0902121659460.5658@fbirervta.pbzchgretzou.qr>
Date: Fri, 13 Feb 2009 20:33:33 +0100
In-Reply-To: <alpine.LSU.2.00.0902121659460.5658@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Thu\, 12 Feb 2009 17\:00\:54 +0100 \(CET\)")
Message-ID: <86tz6ygmia.fsf@johno.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-12, Jan Engelhardt <jengelh@medozas.de> wrote:
>>+By opening the device /dev/dazukofs.0 an application has registered itself.
>>+A read on the device will block until a file access event on DazukoFS has
>>+taken place. When a file access event has occured, the read will return with
>>+information about the file access event. For example:
>
> Given that there are more device files to come, I would
> put this into a separate directory, /dev/dazukofs/0, much
> like dm-crypt does for its devices.

I was not sure if I should leave it up to udev rules to organize
things. I agree that putting everything under a directory is cleaner.
I will make this change for the next patch series.

John Ogness
