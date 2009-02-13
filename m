Return-Path: <linux-kernel-owner+w=401wt.eu-S1761852AbZBMUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852AbZBMUXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762002AbZBMUWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:22:16 -0500
Received: from langrock.org ([87.230.25.171]:58162 "EHLO langrock.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761984AbZBMUWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:22:15 -0500
X-Greylist: delayed 2546 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 15:22:15 EST
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: John Ogness <dazukocode@ogness.net>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, malware-list@lists.printk.net,
       eparis@redhat.com, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 2/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <john@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<m1r623ct11.fsf@fess.ebiederm.org>
Date: Fri, 13 Feb 2009 20:39:32 +0100
In-Reply-To: <m1r623ct11.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 12 Feb 2009 12\:14\:02 -0800")
Message-ID: <863aei3z4b.fsf@lonestar.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (berkeley-unix)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-12, ebiederm@xmission.com (Eric W. Biederman) wrote:
> Please use struct pid properly.
>
> There is no guarantee that whoever opens /dev/dazukofs.0 will
> be in the global pid namespace.
>
> So you need to properly store a struct pid reference in your data
> structures, and call pid_vnr just before you pass the value to
> userspace.

Thanks. I was not aware of pid.h. I will make this change.

John Ogness
