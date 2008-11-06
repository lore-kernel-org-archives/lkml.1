Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYKFIa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYKFIa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYKFIas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:30:48 -0500
Received: from mail.ocs.com.au ([202.134.241.204]:17235 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYKFIar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:30:47 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-16) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: "Peter Teoh" <htmldeveloper@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: USB HDD or filesystem bugs? 
In-reply-to: Your message of "Thu, 06 Nov 2008 16:27:14 +0800."
             <804dabb00811060027j505d155egf4092864d9b44847@mail.gmail.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 06 Nov 2008 19:30:44 +1100
Message-ID: <1910.1225960244@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter Teoh" (on Thu, 6 Nov 2008 16:27:14 +0800) wrote:
>Aborting journal on device sdi1.
>Buffer I/O error on device sdi1, logical block 1544
>lost page write due to I/O error on sdi1
>journal_bmap: journal block not found at offset 20 on sdh3

To rule out filesystem corruption, as root do 'umount /dev/sdi1' then
run 'badblocks /dev/sdi1'.  badblocks will find any real I/O problems,
if there are none then you have a corrupt fs.

