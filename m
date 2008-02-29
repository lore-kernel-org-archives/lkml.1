Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbYB2QBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbYB2QBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932391AbYB2QA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:00:57 -0500
Received: from mail.syneticon.net ([213.239.212.131]:42829 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbYB2QA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:00:57 -0500
Message-ID: <47C82C2A.5000301@wpkg.org>
Date: Fri, 29 Feb 2008 17:00:42 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Gordon Mckeown <ml_lkml@thefluffyone.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Very high IOWait during all disk activity
References: <47C82244.60307@wpkg.org> <74d8fc520802290747o2c97992ar7af2b8c295fe2fb2@mail.gmail.com>
In-Reply-To: <74d8fc520802290747o2c97992ar7af2b8c295fe2fb2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gordon Mckeown schrieb:

(...)

> Unfortunately this doesn't help explain why Windows XP on the same box
> can complete an "identical" copy operation in half the time. Perhaps
> it's just due to the different filesystems, or the way write caching
> works?

Did you, at least:

* made a NTFS on that drive for a Windows test
* made a ext3 on that same drive for a Linux test

Or, is Linux using partition A, and Windows using partition B?

If it's the latter, such tests are not very meaningful.

Also, you gave too few details to say anything meaningful, really (did 
you drop cache on both systems before starting copying? did you sync 
after copying on both systems to see how long does it take? etc.).


-- 
Tomasz Chmielewski
http://wpkg.org
