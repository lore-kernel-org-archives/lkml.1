Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbYFVVVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbYFVVVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYFVVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:20:55 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:20166 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbYFVVUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vkrDkoE0f7hFgXyY0C2jLzhqri7T252HCRuNOodcZIDnjiXR4GqNq9S/M/M4HM9h1m
         t5jA3veOy9YIPGd2rH8Kc2BCZNDQzIZCDVnUumYbUucXX+AWf+JCc+y2TWVtEJGMzMPU
         wxS3W9YGGeNLJUGILUz+gsuFy3Q4/rmwYVTGE=
Message-ID: <dd18b0c30806221420t41e4445csf87608da83869a7f@mail.gmail.com>
Date: Sun, 22 Jun 2008 21:20:53 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10959] stuck tcp connections 2.6.26-rc7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4mRZUF-hVeG.A.coD.NtpXIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	 <4mRZUF-hVeG.A.coD.NtpXIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 5:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10959
> Subject         : stuck tcp connections 2.6.26-rc7
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-06-22 18:09 (1 days old)
> References      : http://marc.info/?l=linux-kernel&m=121415821219644&w=4
>
>
>

Yes;
As a short work around setting #define TCP_RTO_MAX	((unsigned)(120*HZ)) to
#define TCP_RTO_MAX	((unsigned)(60*HZ)) in include/net/tcp.h does
help, but the problem is still there.
After testing this setting out for a few days, I decided to revert it
back, so I don't mess my tcp packets up, and feel like an internet hog
regards;


-- 
Justin P. Mattock
