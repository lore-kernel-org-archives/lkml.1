Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbXEPJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbXEPJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbXEPJ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:56:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:14242 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbXEPJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZHFTBVA0zWTLeouyMS8d5nPv8zqtAzNyv6Cis9Kt1qCIF8kfXi3JBWWRcsX2Kr/4acwK5YVNgxRZP/j25PprX/7aNKaeJfiOpZvpqB2LGzAWpsEcJXdTNA57wG54eM3RqM/f1qDxZ8RUpEyE7AJpG8k1F4F+jkhdesSpfjfV30A=
Message-ID: <a781481a0705160256v40d21f1ey986bb26583599b52@mail.gmail.com>
Date: Wed, 16 May 2007 15:26:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.6.22-rc1
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Tilman Schmidt" <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <464AA4D9.3040706@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
	 <Pine.LNX.4.61.0705151009400.9570@yvahk01.tjqt.qr>
	 <a781481a0705151852x2786c0d7sc6a9b6b2a3695ca6@mail.gmail.com>
	 <464AA4D9.3040706@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > * Also, some "[MENU]" kind of prefix/tag in the text of configmenu
> > options would also be nice.
>
> This belongs into the UIs, not into Kconfigs.
> And it'd not just be nice, it's a requirement.

Indeed. "make menuconfig" interprets them specially (suffixes "--->")
and so does "xconfig". Just that the non-curses/graphics-based
scripts/kconfig/conf.c also needs to be taught to treat them specially
and tag something to them. Gaah. What was I smoking ...
