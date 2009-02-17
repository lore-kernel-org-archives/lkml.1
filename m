Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZBQI5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZBQI5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZBQI5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:57:00 -0500
Received: from www.tglx.de ([62.245.132.106]:60428 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZBQI47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:56:59 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 3/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<86skmvfhx6.fsf_-_@johno.fn.ogness.net>
	<m1k57vcsr1.fsf@fess.ebiederm.org>
Date: Tue, 17 Feb 2009 09:55:30 +0100
In-Reply-To: <m1k57vcsr1.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 12 Feb 2009 12\:20\:02 -0800")
Message-ID: <86fxidfnnh.fsf@johno.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-12, ebiederm@xmission.com (Eric W. Biederman) wrote:
>> Patch 3: Creates /dev/dazukofs.ctrl to allow for groups to be added,
>>          listed, and deleted. Also, /dev/dazukofs.[0-9] devices are
>>          created to support multiple groups.
>
> Great another global namespace for process groups.  What is your
> plan for making this work in a container?

It is good that you mention it. This is something that I totally
missed. I am not yet certain what kind of a role DazukoFS should have
within containers.  I need to learn the container API's and see what
kinds of options are available. The next patchset (which it seems
won't be coming too quickly now) will address this in some form.

John Ogness
