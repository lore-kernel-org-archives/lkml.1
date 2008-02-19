Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbYBSOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbYBSOyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYBSOyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:54:24 -0500
Received: from mail.syneticon.net ([213.239.212.131]:53631 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYBSOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:54:22 -0500
Message-ID: <47BAED94.3040103@wpkg.org>
Date: Tue, 19 Feb 2008 15:54:12 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu>
In-Reply-To: <20080218141640.GC12568@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso schrieb:

(...)

> The following ld_preload can help in some cases.  Mutt has this hack
> encoded in for maildir directories, which helps.

It doesn't work very reliable for me.

For some reason, it hangs for me sometimes (doesn't remove any files, rm 
-rf just stalls), or segfaults.


As most of the ideas here in this thread assume (re)creating a new 
filesystem from scratch - would perhaps playing with 
/proc/sys/vm/dirty_ratio and /proc/sys/vm/dirty_background_ratio help a bit?


-- 
Tomasz Chmielewski
http://wpkg.org
