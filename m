Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZAGDMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZAGDMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 22:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZAGDLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 22:11:51 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:32971 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZAGDLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 22:11:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XRuDw/97ERmqtW+kgqqIhjn8Lcu9yp+WdP39KmlqGanbRmEYRdSVwtOLLL9kiNHObD
         NpH+/2GvLpGj3gguf8UK/x5Y8LOZz9n4iDOEFZdWPWqABfLjKkTmVgHV0O81nnteEeb1
         Ho+yREN6IEZgUCCH60/L73mUt0vop+sqGcDek=
Message-ID: <12bfabe40901061911m5f2a1bbco7e2e756129cdca78@mail.gmail.com>
Date: Wed, 7 Jan 2009 04:11:47 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: Half-Disaster switching from ext3 to ext4
In-Reply-To: <20090106004706.GF14500@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40901031923r3a828f71v74a8c6a56746b2ec@mail.gmail.com>
	 <20090106004706.GF14500@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks for your reply!
On Tue, Jan 6, 2009 at 1:47 AM, Theodore Tso <tytso@mit.edu> wrote:
> What version of e2fsprogs do you have installed, and can you dig up
> the exact error message at mount time?  It should be in the your
> system logs....
>
e2fsprogs v. 1.41.3(Debian Unstable/Experimental).
As for the log, I couldn't find any, but I posted the output of
command "grep -r 'sda2' *"(inside /var/log) at the end of the e-mail.
Sorry, I know this isn't much help! Anyway, if I can do anything else, just ask.

(sda2 is the partition which had the problem.)

Regards,
             Giangiacomo

/var/log#grep -r 'sda2' *

dmesg:[    4.706967]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
dmesg.0:[    4.707161]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
installer/syslog:Dec  3 14:48:13 kernel: [   10.427087]  sda: sda1
sda2 sda3 sda4 < sda5 sda6 >
installer/syslog:Dec  3 15:39:16 os-prober: debug: running
/usr/lib/os-probes/50mounted-tests on /dev/sda2
installer/syslog:Dec  3 15:39:16 10freedos: debug: /dev/sda2 is not a
FAT partition: exiting
installer/syslog:Dec  3 15:39:16 10qnx: debug: /dev/sda2 is not a QNX4
partition: exiting
installer/syslog:Dec  3 15:39:16 20microsoft: debug: /dev/sda2 is a
NTFS partition
installer/syslog:Dec  3 15:39:16 20microsoft: result:
/dev/sda2:Windows Vista/Longhorn (loader):Windows:chain
installer/syslog:Dec  3 15:41:01 os-prober: debug: running
/usr/lib/os-probes/50mounted-tests on /dev/sda2
installer/syslog:Dec  3 15:41:01 10freedos: debug: /dev/sda2 is not a
FAT partition: exiting
installer/syslog:Dec  3 15:41:01 10qnx: debug: /dev/sda2 is not a QNX4
partition: exiting
installer/syslog:Dec  3 15:41:01 20microsoft: debug: /dev/sda2 is a
NTFS partition
installer/syslog:Dec  3 15:41:01 20microsoft: result:
/dev/sda2:Windows Vista/Longhorn (loader):Windows:chain
installer/partman:(6079,0,0)	(18260,254,62)	2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:/lib/partman/choose_partition/60partition_tree/choices:
paragraph: 2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:/lib/partman/choose_partition/60partition_tree/choices:
paragraph: 2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:/lib/partman/choose_partition/60partition_tree/choices:
paragraph: 2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:(6079,0,0)	(18260,254,62)	2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:/lib/partman/choose_partition/60partition_tree/choices:
paragraph: 2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
installer/partman:parted_server: OUT:
2	50001477120-150201838079	100200360960	primary	ntfs	/dev/sda2
kern.log:Jan  5 00:36:11 debian-hell kernel: [    4.706967]  sda: sda1
sda2 sda3 sda4 < sda5 sda6 sda7 >
kern.log:Jan  5 00:38:01 debian-hell kernel: [  122.144438] EXT4 FS on
sda2, internal journal on sda2:8
kern.log.1:Dec 30 01:20:25 debian-hell kernel: [    4.694852]  sda:
sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
kern.log.1:Dec 30 01:20:25 debian-hell kernel: [   10.723303] EXT3 FS
on sda2, internal journal
kern.log.1:Jan  2 19:17:15 debian-hell kernel: [323822.317015] EXT4 FS
on sda2, internal journal on sda2:8
kern.log.1:Jan  3 05:01:12 debian-hell kernel: [    4.690035]  sda:
sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
kern.log.1:Jan  3 05:01:12 debian-hell kernel: [   11.111989] EXT4 FS
on sda2, internal journal on sda2:8
kern.log.1:Jan  3 22:41:59 debian-hell kernel: [    4.707161]  sda:
sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
kern.log.1:Jan  3 23:28:40 debian-hell kernel: [ 2813.351732] EXT4 FS
on sda2, internal journal on sda2:8
kern.log.1:Jan  4 02:44:54 debian-hell kernel: [14587.645742] EXT4 FS
on sda2, internal journal on sda2:8
kern.log.1:Jan  4 03:10:02 debian-hell kernel: [16095.721236] EXT4 FS
on sda2, internal journal on sda2:8
messages:Jan  5 00:36:11 debian-hell kernel: [    4.706967]  sda: sda1
sda2 sda3 sda4 < sda5 sda6 sda7 >
messages:Jan  5 00:38:01 debian-hell kernel: [  122.144438] EXT4 FS on
sda2, internal journal on sda2:8
messages.1:Dec 30 01:20:25 debian-hell kernel: [    4.694852]  sda:
sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
messages.1:Dec 30 01:20:25 debian-hell kernel: [   10.723303] EXT3 FS
on sda2, internal journal
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
messages.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
messages.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
messages.1:Jan  2 19:17:15 debian-hell kernel: [323822.317015] EXT4 FS
on sda2, internal journal on sda2:8
messages.1:Jan  3 05:01:12 debian-hell kernel: [    4.690035]  sda:
sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
messages.1:Jan  3 05:01:12 debian-hell kernel: [   11.111989] EXT4 FS
on sda2, internal journal on sda2:8
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
messages.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
messages.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
messages.1:Jan  3 22:41:59 debian-hell kernel: [    4.707161]  sda:
sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
messages.1:Jan  3 23:28:40 debian-hell kernel: [ 2813.351732] EXT4 FS
on sda2, internal journal on sda2:8
messages.1:Jan  4 02:44:54 debian-hell kernel: [14587.645742] EXT4 FS
on sda2, internal journal on sda2:8
messages.1:Jan  4 03:10:02 debian-hell kernel: [16095.721236] EXT4 FS
on sda2, internal journal on sda2:8
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
user.log.1:Dec 31 07:28:04 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
user.log.1:Dec 31 07:28:31 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
user.log.1:Jan  3 22:21:26 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell 10freedos: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell 10qnx: debug: /dev/sda2 is not
a QNX4 partition: exiting
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell 20microsoft: debug: /dev/sda2
is not a MS partition: exiting
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell 30utility: debug: /dev/sda2 is
not a FAT partition: exiting
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda2
user.log.1:Jan  3 22:22:24 debian-hell os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda2
