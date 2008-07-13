Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYGMThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYGMThp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYGMTh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:37:29 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:42549 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbYGMTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vlc2ulZ7F/GoHhft4cfeoXyKs4V1xY0tMDsHbsV909R1m4eYe4eIKuXGbLXfrAIaJ5
         AODnparQpxXgH7Bc7bY4lfp+RjlbpmwetBppgkt0HLb2azvy9k2rwOm8I56iWTFoYtkn
         R5jWDiLYpMRwdrJuOisXId5UkXYCN9zdwecFY=
Message-ID: <dd18b0c30807131237r5afd6d99r26df2956ac962568@mail.gmail.com>
Date: Sun, 13 Jul 2008 19:37:26 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <c6ZRbn0adb.A.si.HIleIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.si.HIleIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 6:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10954
> Subject         : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-06-21 2:05 (23 days old)
> References      : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
>                  http://marc.info/?t=121416231700010&r=1&w=4
>
>
>

yes;
after running a small test of removing options snd-hda-intel position_fix=1
out of /etc/modprobe.d I was still receiving this message, but instead
of twice in a row
like it was doing, I am only seeing this happen occasionally once.

-- 
Justin P. Mattock
