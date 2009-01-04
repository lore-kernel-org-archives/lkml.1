Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbZADAAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbZADAAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZADAAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:00:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:61899 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062AbZADAAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rn38uYN1P36LafpKTwrgw6Alh5A5W3aIHabTAkLzGdNDyiOwjA98qMhohx6IWP3KoN
         /GnhIWM19AGBEJIJc44cv5l4MYFlSn1ACGk92DtveOCkBJZE7pwL5u80Ywhl2iVvDWXp
         MgVddXWPa+Oo2R9WZB6Wecg6OiKe822PMXOXc=
Message-ID: <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
Date: Sun, 4 Jan 2009 00:00:40 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: document ext3 requirements
Cc: "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
In-Reply-To: <495FF9CE.2020908@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090103123813.GA1512@ucw.cz>
	 <495FD5D7.2040907@ribosome.natur.cuni.cz>
	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
	 <20090103222957.GG1666@elf.ucw.cz>
	 <495FEE66.9080903@ribosome.natur.cuni.cz>
	 <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com>
	 <495FF9CE.2020908@ribosome.natur.cuni.cz>
X-Google-Sender-Auth: b6770eb170978868
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
> Why does not "mount -ro" die when it would have to replay the journal
> with a message that user must run fsck.ext3 in order to be able to mount
> it albeit read-only? Still I would prefer having an extra switch to
> force mount RO while not touching the journal for disk forensics.
> I think that would also prevent the cases when a LiveCD/rescue distribution
> would not mount+replay it automagically but user would really have to
> provide the switch to the command. I am really not using the recovery
> boot cd to touch my partitions in some cases unwillingly.

Well, that would make things rather tricky. As in, shutting down
uncleanly would render your system unbootable.

> Sure that does not prevent my case when I let ext2 IFS writing onto
> my ext3 partition. Actually, couldn't the driver at least warn me
> the journal log is non-empty (am just a user, sorry, cannot check
> myself the code at www.fs-driver.org if it could do at least this
> although it does not understand ext3). ;-)

The driver certainly should warn you in that case. I have no idea
whether it does, as I don't use it, sorry.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
