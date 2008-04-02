Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYDBQCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYDBQCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbYDBQCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:02:23 -0400
Received: from ns1.bluetone.cz ([212.158.128.13]:58923 "EHLO ns1.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515AbYDBQCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:02:22 -0400
X-Greylist: delayed 8047 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 12:02:22 EDT
Message-ID: <47F38E90.20306@slax.org>
Date: Wed, 02 Apr 2008 15:48:00 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [GIT PULL -mm] 00/14 VFS/Unionfs updates/fixes/cleanups
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Based on recommendations we've received while at LSF'08, we've changed
>    Unionfs to use the vm_operations->fault method, instead of
>    address_space_operations.  This makes unionfs's code smaller, runs faster
>    (reduce memory pressure), and removes a number of potential races.  This
>    change is significant ...

Interesting to see you're finally switching to the approach,
which is in AUFS for ages.

May I ask you, why did it took so long?
Mainly, why did you refused to make the changes last year?

Thank you


Tomas M

