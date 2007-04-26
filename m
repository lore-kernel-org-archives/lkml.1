Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbXDZTXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbXDZTXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbXDZTXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:23:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39952 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbXDZTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:23:18 -0400
Date: Thu, 26 Apr 2007 21:10:04 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] unprivileged mounts update
In-Reply-To: <m1r6q8s735.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.61.0704262107130.506@yvahk01.tjqt.qr>
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
 <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <m1r6q8s735.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 25 2007 11:21, Eric W. Biederman wrote:
>>
>> Why did we want to use fsuid, exactly?
>
>- Because ruid is completely the wrong thing we want mounts owned
>  by whomever's permissions we are using to perform the mount.

Think nfs. I access some nfs file as an unprivileged user. knfsd, by
nature, would run as euid=0, uid=0, but it needs fsuid=jengelh for
most permission logic to work as expected.


Jan
-- 
