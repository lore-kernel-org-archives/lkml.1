Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZALNjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZALNjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZALNjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:39:36 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:37318 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZALNjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LwF0hLy+FeIgkLuvXpEXTJlmg0VIlvp6YqJ1+H/PsFurw0qnNlRV+HBhNQhcF0anz6
         1R13Wal6DjX8UG5i8SIsyhX8bX0PaJemgqQGRj0dyCVKuE5ofpWSzg+M40EW7fj60LLG
         myP+up/bxTxL2ElVUK6obfMke7cWBspSeARhE=
Message-ID: <170fa0d20901120539w4e3bbc03na39f01edde206d25@mail.gmail.com>
Date: Mon, 12 Jan 2009 08:39:33 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>
Subject: Re: Online ext4 defragmention
Cc: "Alex Buell" <alex.buell@munted.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
In-Reply-To: <20090111202838.GA29383@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090111134443.581cfc83@lithium.local.net>
	 <20090111202838.GA29383@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 3:28 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sun, Jan 11, 2009 at 01:44:43PM +0000, Alex Buell wrote:
>> Can someone confirm if the online ext4 defragmentation ioctls will
>> be going into 2.6.29? Thanks, I'm planning a migration from a
>> disparate collection of filesystems to ext4 over the next few months.
>
> Unfortunately, the defragmentation patches need to a lot of work (to
> be honest, largely refactored and almost rewritten) before they are
> ready to for mainline yes.  I am also concerned that the current
> defrag patches also try too hard to keep blocks in the same block
> group, even as a higher priority keeping them non-fragmented.
>
> Also, note that some of the benefits of ext4 only show up if you do a
> backup, mkfs, and restore; that's because there are layout changes
> that can only take place if you reformat the filesystem.  Finally,
> there are some allocation algorithm changes which didn't make the
> 2.6.29 merge window which I think will make a long-term difference.
> So you'll probably want to use 2.6.29 with the ext4 patch set.

Hi Ted,

Could you elaborate on which allocation patches you're referring to in
the ext4 patch queue (2.6.28-ext4-3?) ?

Thanks,
Mike
