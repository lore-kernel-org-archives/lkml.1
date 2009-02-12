Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZBLUUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZBLUUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbZBLUT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:19:57 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60110 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311AbZBLUT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:19:56 -0500
To: John Ogness <dazukocode@ogness.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 3/5] VFS: DazukoFS, stackable-fs, file access control
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<86wsc7fhzc.fsf_-_@johno.fn.ogness.net>
	<86skmvfhx6.fsf_-_@johno.fn.ogness.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Feb 2009 12:20:02 -0800
In-Reply-To: <86skmvfhx6.fsf_-_@johno.fn.ogness.net> (John Ogness's message of "Tue\, 03 Feb 2009 20\:18\:29 +0100")
Message-ID: <m1k57vcsr1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: dazukocode@ogness.net, alan@lxorguk.ukuu.org.uk, hch@infradead.org, eparis@redhat.com, malware-list@lists.printk.net, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Ogness <dazukocode@ogness.net> writes:

> Patch 3: Creates /dev/dazukofs.ctrl to allow for groups to be added,
>          listed, and deleted. Also, /dev/dazukofs.[0-9] devices are
>          created to support multiple groups.

Great another global namespace for process groups.  What is your plan
for making this work in a container?

Eric
