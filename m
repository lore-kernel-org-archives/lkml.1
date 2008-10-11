Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYJKWK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYJKWK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 18:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYJKWKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 18:10:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbYJKWKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 18:10:16 -0400
Message-ID: <48F12427.5090801@redhat.com>
Date: Sat, 11 Oct 2008 17:09:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/42] ext4: Rename ext4dev to ext4
References: <1223525160-9887-1-git-send-email-tytso@mit.edu> <1223525160-9887-26-git-send-email-tytso@mit.edu> <1223525160-9887-27-git-send-email-tytso@mit.edu> <1223525160-9887-28-git-send-email-tytso@mit.edu> <1223525160-9887-29-git-send-email-tytso@mit.edu> <1223525160-9887-30-git-send-email-tytso@mit.edu> <1223525160-9887-31-git-send-email-tytso@mit.edu> <1223525160-9887-32-git-send-email-tytso@mit.edu> <1223525160-9887-33-git-send-email-tytso@mit.edu> <1223525160-9887-34-git-send-email-tytso@mit.edu> <1223525160-9887-35-git-send-email-tytso@mit.edu> <1223525160-9887-36-git-send-email-tytso@mit.edu> <1223525160-9887-37-git-send-email-tytso@mit.edu> <1223525160-9887-38-git-send-email-tytso@mit.edu> <1223525160-9887-39-git-send-email-tytso@mit.edu> <1223525160-9887-40-git-send-email-tytso@mit.edu> <1223525160-9887-41-git-send-email-tytso@mit.edu> <1223525160-9887-42-git-send-email-tytso@mit.edu> <1223525160-9887-43-git-send-email-tytso@mit.edu> <48F122FC.6040107@goop.org>
In-Reply-To: <48F122FC.6040107@goop.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Theodore Ts'o wrote:
>> The ext4 filesystem is getting stable enough that it's time to drop
>> the "dev" prefix.  Also remove the requirement for the TEST_FILESYS
>> flag.
>>   
> 
> Shouldn't you still register "ext4dev" as a filesystem type, so that old 
> setups won't suddenly break?  I just had this happen to me; I had to 
> work out why /home didn't mount.

Yep, we've discussed that and I think it'll get added.

It should probably go away at some point, but it'd be good at least for
a transition period.

Jeremy, btw the latest fedora kernels should fix your xattr hang :)

-Eric

>> +obj-$(CONFIG_EXT4_FS)		+= ext4/ # Before ext2 so root fs can be ext4dev
>>   
> 
> s/ext4dev/ext4/
> 
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

