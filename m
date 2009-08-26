Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZHZJHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZHZJHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZHZJHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:07:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40882 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZHZJHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:07:01 -0400
To: Eric Paris <eparis@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: v2.6.31-rc6 inotify not reporting deleted files
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 26 Aug 2009 02:06:58 -0700
Message-ID: <m1skffj64t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: eparis@redhat.com, rjw@sisk.pl, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't have a small test case yet, but I have an application that
uses inotify and watches a file and takes action when that file has been
deleted.  Running that application on 2.6.31-rc6 the application is
no longer seeing the file being deleted.

With luck a word to the wise is all that is required for you to reproduce
this.  Otherwise I will spend some time tomorrow making a small reproducer.

Eric


