Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZLJIts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZLJIts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbZLJItn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:49:43 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50949 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZLJItm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:49:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EcqWHLhE1fcxObh6yjN6/d66URlRtdT9nY9FjYfb2rezUxzD5UlrVGtVinfuQjM2+2
         TIJlHr0MAuelpo2/j93Vi/b9ge/mMfHUKCU8KYv3tqCb2dvlvvnGl1VaEMzZoX8/2+PF
         KjPWK15xicbntaaulyrDEgzMAJwIi1rhgqzL4=
MIME-Version: 1.0
In-Reply-To: <20091112162026.GJ14528@duck.suse.cz>
References: <195c7a900911112329v7df8e718s5c0a5babdea39b99@mail.gmail.com>
	 <20091112124238.GH14528@duck.suse.cz>
	 <20091112162026.GJ14528@duck.suse.cz>
Date: Thu, 10 Dec 2009 09:49:48 +0100
Message-ID: <195c7a900912100049p3916a487rfd1ff75dc79d2b77@mail.gmail.com>
Subject: Re: warn on lookup_one_length/vfs_quota_on_mount
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 5:20 PM, Jan Kara <jack@suse.cz> wrote:
>  Hello,
>
> On Thu 12-11-09 13:42:38, Jan Kara wrote:
>> On Thu 12-11-09 08:29:06, Bastien ROUCARIES wrote:
>> > I get the following warm on my reiserfs disk with quota enabled at
>> > boot (each boot) see
>> > http://www.kerneloops.org/raw.php?rawid=937752&msgid=
>> > *lookup_one_len
>> > ? lookup_one_len
>> > ? lookup_one_len
>> > ? warn_slowpath_common
>> > ? lookup_one_len
>> > ? vfs_quota_on_mount
>> > ? finish_unfinished
>> > ? reiserfs_remount
>> > ? __filemap_fdatawrite_range
>> > ? do_remount_sb
>> > ? do_mount
>> > ? sys_mount
>> > ? system_call_fastpath
[...]
>  Attached patch fixes the warning for me.

Sorry for the late reply. Fix for me also

thanks

bastien
