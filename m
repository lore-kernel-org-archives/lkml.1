Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYGMVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYGMVnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYGMVnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:43:12 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:40374 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbYGMVnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:43:11 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #10865] Oops trying to mount an ntfs partition on thinkpad
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	<c6ZRbn0adb.A.D3.1IleIB@albercik>
Date: Sun, 13 Jul 2008 14:42:49 -0700
In-Reply-To: <c6ZRbn0adb.A.D3.1IleIB@albercik> (rjw@sisk.pl)
Message-ID: <877ibp31gm.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10865
> Subject		: Oops trying to mount an ntfs partition on thinkpad
> Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
> Date		: 2008-06-05 14:47 (39 days old)
> References	: http://marc.info/?l=linux-kernel&m=121267834421414&w=4
>

just tried it with rc9-git12 and now it seems to work but i get a
warning:

  NTFS volume version 3.1.
  NTFS-fs warning (device sda1): load_system_files(): Unsupported volume flags 0x4000 encountered.
  NTFS-fs error (device sda1): load_system_files(): Volume has unsupported flags set.  Mounting read-only.  Run chkdsk and mount in Windows.

i'll try to boot into windows and run chkdsk to see if it makes the
warning go away.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
