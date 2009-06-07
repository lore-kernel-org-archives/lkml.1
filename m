Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZFGRQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZFGRQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZFGRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:16:17 -0400
Received: from blaine.gmane.org ([80.91.229.8]:40187 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbZFGRQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J7J8m8ievi6tOuyINlYOmTmgJHZumG9nMYdAzKIwH/yyVgDAyO6ORhpeGI+d4UY8Vb
         lCgjNLMyc5yzFHitYTk1slP0/2bzONbSgUBrGDj00V7DjSwFMdsPfkDMCMyfnXoSAoKI
         dUFLpoyt1kT8NnWJNIPvffVOlXH0U6j7epywQ=
Message-ID: <4A2BF577.1050003@gmail.com>
Date: Sun, 07 Jun 2009 11:14:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@hugh.gmane.org>
CC: Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Daniel Bierstedt 
	<public-daniel.bierstedt-Mmb7MZpHnFY@hugh.gmane.org>
Subject: Re: [Bug #13072] forcedeth seems to switch off eth on shutdown
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.ELC.ck7KKB@chimera>
In-Reply-To: <AN6kEAA5GQ.A.ELC.ck7KKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMDA-Confirmed: Sun, 07 Jun 2009 19:15:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13072
> Subject		: forcedeth seems to switch off eth on shutdown
> Submitter	: Daniel Bierstedt <daniel.bierstedt-Mmb7MZpHnFY@public.gmane.org>
> Date		: 2009-04-12 07:00 (57 days old)

Seems like it should be fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5a9a8e32ebe269c71d8d3e78f9435fe7729f38e9


