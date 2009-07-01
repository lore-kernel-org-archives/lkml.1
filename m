Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZGAA22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZGAA22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZGAA2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:28:21 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:46929 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZGAA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:28:20 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: steve@digidescorp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FAT: optimize FSINFO writeback
References: <1246392130-4261-1-git-send-email-steve@digidescorp.com>
	<87ocs5h238.fsf@devron.myhome.or.jp>
	<1246400345.2247.4.camel@iscandar.digidescorp.com>
Date: Wed, 01 Jul 2009 09:28:20 +0900
In-Reply-To: <1246400345.2247.4.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Tue, 30 Jun 2009 17:19:05 -0500")
Message-ID: <873a9hfdqz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> Well, now, we are using sb->s_dirty for fsinfo, so I'm wondering why
>> this happen frequently.
>
> My scenario was modifying a sector of an existing file and using
> fdatasync() to flush it. The FSINFO sector was being updated even though
> nothing about the FAT layout had changed.

I see. Probably, I'm missing something, or handling of sb->s_dirt may be
buggy, or something.

If it was fixed, is this patch still needed?  I guess this patch would
still be useful on some case though.  If you can explain, it would be
good.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
