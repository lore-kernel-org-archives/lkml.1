Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZKLH3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZKLH3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZKLH3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:29:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:10115 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZKLH3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:29:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cXkjPZp5zZUdoK6mAmGlqCC5G8/QJ1fNmjf8Vt/DA5bm7KEig9YWQiXuvkJbTwvcDn
         8ppJ8wWGt+cgq5f2yuBhPAgw5n7aGFFW9obj40RhWNWFnEn/WK5k4drSmGNJs11izqTj
         LUxEdznoAPPA7p/Oqz2bvI2yzS9SX9wnPROAI=
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 08:29:06 +0100
Message-ID: <195c7a900911112329v7df8e718s5c0a5babdea39b99@mail.gmail.com>
Subject: warn on lookup_one_length/vfs_quota_on_mount
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear developer,

I get the following warm on my reiserfs disk with quota enabled at
boot (each boot) see
http://www.kerneloops.org/raw.php?rawid=937752&msgid=
*lookup_one_len
? lookup_one_len
? lookup_one_len
? warn_slowpath_common
? lookup_one_len
? vfs_quota_on_mount
? finish_unfinished
? reiserfs_remount
? __filemap_fdatawrite_range
? do_remount_sb
? do_mount
? sys_mount
? system_call_fastpath

But it seems a generic bug in the quota layer due to:
http://www.kerneloops.org/oops.php?number=799645
http://www.kerneloops.org/oops.php?number=700122

Thank you

Bastien
