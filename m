Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYF2DgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYF2DgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 23:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYF2Df4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 23:35:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:62583 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYF2Dfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 23:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=In4SYL/wfvY18At/NUMtblE05DJCbDUMdIZAWUimSRl3E23hD/Znk0scRlL7lUaULD
         +8OZoxuMag3Qix7nehHMjkKw53nYviZXJnIPap0SWFKenZYUnUJQgPgdjcfS8oztc+i5
         WKa6njxJvULql5lZal3BPNSwsu2WPQ5ik7++E=
Message-ID: <48670308.5020301@gmail.com>
Date: Sun, 29 Jun 2008 12:35:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 07/11] sysfs: Implement sysfs_delete_link and sysfs_rename_link
References: <20080618170729.808539948@theryb.frec.bull.fr>	<20080618170731.153832341@theryb.frec.bull.fr>	<485F06B8.6090902@gmail.com> <m1od5ovt9s.fsf@frodo.ebiederm.org>
In-Reply-To: <m1od5ovt9s.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>> Ugly but given the current interface limitations...
> 
> Yep.  I have been thinking it might be nice to look at what you did with magic symlink
> handling.  Otherwise we either need to convert everything from sysfs_remove_link to
> sysfs_delete_link if we don't want to play whack a mole.

I think the current one should do for now.  Changing to managed links
requires pervasive changes to locking and stuff.  I'll clean them up
when I refresh the patches I posted a while back.

Thanks.

-- 
tejun
