Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbXBKAyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbXBKAyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXBKAyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:54:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbXBKAyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:54:04 -0500
Date: Sat, 10 Feb 2007 19:54:00 -0500
From: Dave Jones <davej@redhat.com>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: val_henson@linux.interl.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting MS_RELATIME
Message-ID: <20070211005400.GC6849@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michael Kerrisk <mtk-manpages@gmx.net>, val_henson@linux.interl.com,
	lkml <linux-kernel@vger.kernel.org>
References: <45CE0737.6010103@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CE0737.6010103@gmx.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 09:56:07AM -0800, Michael Kerrisk wrote:
 > Val,
 > 
 > I'm just updating the mount(2) man page for MS_RELATIME, and this is the
 > text I've come up with:
 > 
 >        MS_RELATIME(Since Linux 2.6.20)
 >               When a file on this file system is accessed, only
 >               update  the  file's last accessed time (atime) if
 >               the current value of atime is less than or  equal
 >               to  the file's last modified (mtime) or last sta-
 >               tus change time (ctime).  This option  is  useful
 >               for  programs, such as mutt(1), that need to know
 >               when a file has been read since it was last modi-
 >               fied.
 > 
 > This text is based on your comments accompanying the various patches, but
 > it differs in a respect.  Your comments said that the atime would only be
 > updated if the atime is older than mtime/ctime.  However, what the code
 > actually does is update atime if it is is <= mtime/ctime -- i.e., atime is
 > older than or *or equal to* mtime/ctime.
 > 
 > I'm sure that the code implements your intention, but before incorporating
 > the above text I thought I just better check, since the code differs from
 > your comment.  Can you just confirm that the proposed man page text is okay.

Whilst on the subject of RELATIME, is there any good reason why
not to make this a default mount option ?

		Dave

-- 
http://www.codemonkey.org.uk
