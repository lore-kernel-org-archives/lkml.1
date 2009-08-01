Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZHAQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZHAQct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZHAQcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 12:32:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:8346 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZHAQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 12:32:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HUdj/t2ZQwO2144v2WXrwMDUQOHBgji9lI6N7UEc+3Ulyq9SyQhE+pf5756UupxqC4
         svRoDdjBu9J/cPA6U47Qcv/ulpGuu46AoimlPs5zZe1tjTm4pMhuzETMfnSzOcY4v2ke
         BaH8DbU292EEaxWhmzNTfNPLRntvYf3gpeM4w=
Message-ID: <4A746E24.1050401@gmail.com>
Date: Sat, 01 Aug 2009 18:32:36 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Watts <akwatts@ymail.com>
CC: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Bug report (suspend to disk is broken in 2.6.29+ with EIDE drive)
References: <937390.49428.qm@web111003.mail.gq1.yahoo.com>
In-Reply-To: <937390.49428.qm@web111003.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Watts wrote:
> Description: s2disk worked in 2.6.28 and no longer works in 2.6.30.2
> (s2disk here means: echo disk > /sys/power/state); screen blanks but
> system hangs.
> 
> Bisection reveals that the problem commit has hash:
> 295f00042aaf6b553b5f37348f89bab463d4a469.
> 
> ~Andy
> 
> PS I wrote some months ago about a thermal problem on my HW with
> 2.6.28 (needed noapic, nolapic to have it not run hot @ idle).
> This problem has disappeared in 2.6.30.2. Any devs have an idea what
> commit fixed this?

Adding CCs
