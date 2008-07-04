Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYGDGed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYGDGed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbYGDGeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:34:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:25227 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbYGDGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lNsmRfOGW46NUE2iOm7M8Tmj0LEgXctSJUAJGsFroZtvTNd579bPsQnFtCOIo+6ma6
         Gul/OXfSBIs6RVQd5+0B1XrYmEvMj1jLJa7mdKV5iZ0gmhJmZ1jctSgkhMAuwavbdCPK
         M5fp48GJQ6ZTEXDJqVXwIi5yAQLholNhuwZbg=
Message-ID: <486DC433.9040200@gmail.com>
Date: Fri, 04 Jul 2008 15:33:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 01/15] kobject: Cleanup kobject_rename and !CONFIG_SYSFS
References: <20080618170729.808539948@theryb.frec.bull.fr>	<20080618170731.002784342@theryb.frec.bull.fr>	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org>	<486CF71F.5090405@gmail.com> <m1y74iiidz.fsf_-_@frodo.ebiederm.org> <m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
In-Reply-To: <m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> It finally dawned on me what the clean fix to sysfs_rename_dir
> calling kobject_set_name is.  Move the work into kobject_rename
> where it belongs.  The callers serialize us anyway so this is
> safe.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Nice clean up.  Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
