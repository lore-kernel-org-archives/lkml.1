Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbZEAQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbZEAQhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759078AbZEAQh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:37:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55396 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZEAQhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ERVZnf2GKCumDmMIJzSTPcFtelTQGoenvzjQJeCi6eC7rmCPyj5LcMXDN9vVBfdUix
         X7WBjwe8DLej5yUfzREmhuLr1BeUdqDRhf2PU6hHFqMwjh5J9cn0hF7JLYTgffxWyPI9
         RP34PgAcnTW83kV4ZH3OgF4CW/hwZbQLl6eZI=
MIME-Version: 1.0
In-Reply-To: <49FB1F20.8040400@suse.com>
References: <49FB1F20.8040400@suse.com>
Date: Fri, 1 May 2009 20:37:22 +0400
Message-ID: <a4423d670905010937k395a0a2r2e2b3b68ffe68851@mail.gmail.com>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, David <david@unsolicited.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/1 Jeff Mahoney <jeffm@suse.com>:
>  2.6.30-rc3 introduced some sanity checks in the VFS code to avoid NFS
>  bugs by ensuring that lookup_one_len is always called under i_mutex.
>
>  This patch expands the i_mutex locking to enclose lookup_one_len. This was
>  always required, but not not enforced in the reiserfs code since it
>  does locking around the xattr interactions with the xattr_sem.
>
>  This is obvious enough, but it survived an overnight 50 thread ACL test.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>

It works, thanks.
