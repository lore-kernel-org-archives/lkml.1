Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbYFLOeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbYFLOeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYFLOd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:33:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYFLOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qY70qinkNVD3h3OKkLCasRLYo67iz0yPTEaU7iOuh52xnU8T2bwjY170AOAUtZRSH/
         ytW+O5SrrPuZj96a3radT8SNQLZDLI7rwsp15byP4LyuOMl3jrBk1+sAUcsiEofJyfF0
         dy9n9Uhm6t4pdWHrAHspZ/cy9/e4X2O7Or3NQ=
Message-ID: <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com>
Date: Thu, 12 Jun 2008 16:33:53 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: lists@ku-gbr.de
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c
Cc: linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@infradead.org>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com
In-Reply-To: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add CC's

On 6/12/08, lists@ku-gbr.de <lists@ku-gbr.de> wrote:
> Hi!
>
> Today morning my server at home bailed out two times (reboot between):
>
> Jun 12 07:23:40 zappa Filesystem "sda7": XFS internal error
> xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller
> 0xffffffff802fa8f5
> Jun 12 07:23:40 zappa Pid: 2379, comm: procmail Not tainted
> 2.6.25-gentoo-r4 #3
> Jun 12 07:23:40 zappa
> Jun 12 07:23:40 zappa Call Trace:
> Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
> Jun 12 07:23:40 zappa [<ffffffff802f4d71>]
> Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
> Jun 12 07:23:40 zappa [<ffffffff803038bb>]
> Jun 12 07:23:40 zappa [<ffffffff8025f1e1>]
> Jun 12 07:23:40 zappa [<ffffffff80261899>]
> Jun 12 07:23:40 zappa [<ffffffff8025ae00>]
> Jun 12 07:23:40 zappa [<ffffffff80257010>]
> Jun 12 07:23:40 zappa [<ffffffff80256d92>]
> Jun 12 07:23:40 zappa [<ffffffff80257077>]
> Jun 12 07:23:40 zappa [<ffffffff8020ad3b>]
> Jun 12 07:23:40 zappa
> Jun 12 07:23:40 zappa xfs_force_shutdown(sda7,0x8) called from line
> 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802f4d8a
> Jun 12 07:23:40 zappa Filesystem "sda7": Corruption of in-memory data
> detected.  Shutting down filesystem: sda7
> Jun 12 07:23:40 zappa Please umount the filesystem, and rectify the
> problem(s)
>
> Jun 12 08:15:58 zappa Filesystem "sda7": XFS internal error
> xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller
> 0xffffffff802fa8f5
> Jun 12 08:15:58 zappa Pid: 2161, comm: procmail Not tainted
> 2.6.25-gentoo-r4 #3
> Jun 12 08:15:58 zappa
> Jun 12 08:15:58 zappa Call Trace:
> Jun 12 08:15:58 zappa [<ffffffff802fa8f5>]
> Jun 12 08:15:58 zappa [<ffffffff802f4d71>]
> Jun 12 08:15:58 zappa [<ffffffff802fa8f5>]
> Jun 12 08:15:58 zappa [<ffffffff803038bb>]
> Jun 12 08:15:58 zappa [<ffffffff8025f1e1>]
> Jun 12 08:15:58 zappa [<ffffffff80261899>]
> Jun 12 08:15:58 zappa [<ffffffff8025ae00>]
> Jun 12 08:15:58 zappa [<ffffffff80257010>]
> Jun 12 08:15:58 zappa [<ffffffff80256d92>]
> Jun 12 08:15:58 zappa [<ffffffff80257077>]
> Jun 12 08:15:58 zappa [<ffffffff8020ad3b>]
> Jun 12 08:15:58 zappa
> Jun 12 08:15:58 zappa xfs_force_shutdown(sda7,0x8) called from line
> 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802f4d8a
> Jun 12 08:15:58 zappa Filesystem "sda7": Corruption of in-memory data
> detected.  Shutting down filesystem: sda7
> Jun 12 08:15:58 zappa Please umount the filesystem, and rectify the
> problem(s)
>
>
> The partitition sda7 is my /home directory located on a SATA 750GB
> Harddisk, kernel is vanilla 2.6.25. The fs is 100GB sized and 12%
> filled with several small files (imap mailspool).
>
> I investigated the system and while anything else behaves normal, I
> found no error in syslog or with smartctl regarding a possible sector
> reaad/write error or anything else.
> Sadly I lost my ssh connection now until this evening, but xfs_check
> put out a line like "xxx-count is 1 but counted 0 in ag17" after I was
> instructed to remount the system once to replay the log (which
> worked). Backups are finished, I wanted to run xfs_repair now...
>
> Is this something I should worry about or the xfs Folks?
>
> Kind Regards, Konsti
>
>
> ----------------------------------------------------------------
> This message was sent using IMP, the Internet Messaging Program.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
