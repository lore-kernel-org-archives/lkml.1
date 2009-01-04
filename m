Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbZADAMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbZADAMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbZADAL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:11:58 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:38521 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062AbZADAL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:11:57 -0500
Message-ID: <495FFECB.5040001@ribosome.natur.cuni.cz>
Date: Sun, 04 Jan 2009 01:11:55 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081227 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Duane Griffin <duaneg@dghda.com>
CC: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz>	 <495FD5D7.2040907@ribosome.natur.cuni.cz>	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>	 <20090103222957.GG1666@elf.ucw.cz>	 <495FEE66.9080903@ribosome.natur.cuni.cz>	 <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com>	 <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
In-Reply-To: <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duane Griffin wrote:
> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
>> Why does not "mount -ro" die when it would have to replay the journal
>> with a message that user must run fsck.ext3 in order to be able to mount
>> it albeit read-only? Still I would prefer having an extra switch to
>> force mount RO while not touching the journal for disk forensics.
>> I think that would also prevent the cases when a LiveCD/rescue distribution
>> would not mount+replay it automagically but user would really have to
>> provide the switch to the command. I am really not using the recovery
>> boot cd to touch my partitions in some cases unwillingly.
> 
> Well, that would make things rather tricky. As in, shutting down
> uncleanly would render your system unbootable.

??? If I am booted off a CD/DVD drive I just do not want my system
to be touched. I am fine if the dist mounts my drives automagically
in read-only mode but if that currently forces journal replay then no,
thanks. ;)

M.

