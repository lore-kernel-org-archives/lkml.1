Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbYANU1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbYANU1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYANU10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:27:26 -0500
Received: from ping.uio.no ([129.240.78.2]:45863 "EHLO ping.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYANU1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:27:25 -0500
X-Greylist: delayed 2033 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 15:27:25 EST
From: ilmari@ilmari.org (Dagfinn Ilmari =?utf-8?Q?Manns=C3=A5ker?=)
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibly silly Q?
Organization: Program-, Informasjons- og Nettverksteknologisk Gruppe, UiO
References: <200801141434.00934.gene.heskett@gmail.com>
Mail-Copies-To: nobody
Date: Mon, 14 Jan 2008 19:53:25 +0000
In-Reply-To: <200801141434.00934.gene.heskett@gmail.com> (Gene Heskett's
	message of "Mon, 14 Jan 2008 14:34:00 -0500")
Message-ID: <d8jmyr8xjyi.fsf@nygaard.ping.uio.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Exiscan-Spam-Score: -6.4 (------)
X-Exiscan-Spam-Report: SpamAssassin 3.2.3 (2007-08-08) on rossum.ping.uio.no
	Score  Rule
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -5.0 PING_UIO_MAIL_IS_INTERNAL Message has never been outside
	*      129.240.0.0/16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett <gene.heskett@gmail.com> writes:

> Greetings;
>
> Do we have a utility that can force the kernel to re-read, and re-initialize 
> itself to a given drives partition tables without having to reboot if one is 
> working with a drive that is not part of the required kernel directory tree?
[…]
> Something it seems to me, should have forced the re-init, but didn't.  So is 
> there a tool that can force that?

fdisk or similar should have issued an ioctl to reread the partition
table after writing the new one, but you can do it manually with
'blockdev --rereadpt <device>'.

-- 
ilmari
"A disappointingly low fraction of the human race is,
 at any given time, on fire." - Stig Sandbeck Mathisen
