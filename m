Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbZC3TTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbZC3TTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbZC3TSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:18:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:58261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759713AbZC3TSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:18:34 -0400
Message-ID: <49D11AF2.9030701@suse.com>
Date: Mon, 30 Mar 2009 15:18:10 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 32/35 code-cleanup] reiserfs: rename p_s_inode to inode
References: <20090330180215.951354436@suse.com>	<20090330181013.465420330@suse.com> <87tz5alua4.fsf@basil.nowhere.org>
In-Reply-To: <87tz5alua4.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen wrote:
> Jeff Mahoney <jeffm@suse.com> writes:
>> --- a/fs/reiserfs/file.c
>> +++ b/fs/reiserfs/file.c
>> @@ -137,17 +137,17 @@ static void reiserfs_vfs_truncate_file(s
>>  static int reiserfs_sync_file(struct file *p_s_filp,
>>  			      struct dentry *p_s_dentry, int datasync)
>>  {
>> -	struct inode *p_s_inode = p_s_dentry->d_inode;
>> +	struct inode *inode = p_s_dentry->d_inode;
>>  	int n_err;
>>  	int barrier_done;
> 
> Didn't you miss one here?

Nope. This renamed p_s_inode, and that's a p_s_dentry. That one gets
handled in reiserfs: rename p_._ variables.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknRGvIACgkQLPWxlyuTD7ItdQCgiuVxsIJVzXv66VzTNuRmfF0n
VNgAoJZHYLAtS6mj4Uzxb2+WL/J5Pv+y
=fQ5U
-----END PGP SIGNATURE-----
