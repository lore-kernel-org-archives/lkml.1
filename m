Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZKCWOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZKCWOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZKCWOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:14:02 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45633 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZKCWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:14:01 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/13] sysfs: Update sysfs_setxattr so it updates secdata under the sysfs_mutex
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-1-git-send-email-ebiederm@xmission.com>
	<20091103134823.GB31981@us.ibm.com> <m1ocnj9uz5.fsf@fess.ebiederm.org>
	<20091103213129.GA13555@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 14:13:52 -0800
In-Reply-To: <20091103213129.GA13555@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 3 Nov 2009 15\:31\:29 -0600")
Message-ID: <m1hbtb6yu7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:
>
> Gah, sorry.

No prob.

> Acked-by: Serge Hallyn <serue@us.ibm.com>
>
> (as an aside, I can't see any reason to not just return if strncmp(name,
> XATTR_SECURITY_PREFIX,) above to avoid a level of indent and needless gotos)

Sounds like it is worth a patch.  For now I'm concentrating on getting
this patchset merged, and extraneous cleanups have a way of dragging
the process out beyond what time I have to give.

Eric
