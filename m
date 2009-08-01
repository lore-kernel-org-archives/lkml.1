Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbZHASl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbZHASl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 14:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZHASl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 14:41:28 -0400
Received: from mail-px0-f201.google.com ([209.85.216.201]:62420 "EHLO
	mail-px0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZHASl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 14:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AHZuXRxFAY5qgpKmxJgaboJgFuYAPatf1FplzmN6+PulvntrrhywjvJ3h4d0e7Dg5J
         LqFwjc1B/e1GxeTMl6PWgsINZKm0U9jtbAJB/mVmsB3B87PNQM74pS7+3fs5ES5sIsIq
         6din9tUb6Qq3Cay66yi9LDxwM48YFLDVmD5+U=
Message-ID: <4A748B27.3000902@gmail.com>
Date: Sat, 01 Aug 2009 12:36:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Watts <akwatts@ymail.com>
CC: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Bug report (suspend to disk is broken in 2.6.29+ with EIDE drive)
References: <937390.49428.qm@web111003.mail.gq1.yahoo.com>
In-Reply-To: <937390.49428.qm@web111003.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2009 12:22 AM, Andrew Watts wrote:
> Description: s2disk worked in 2.6.28 and no longer works in 2.6.30.2
> (s2disk here means: echo disk>  /sys/power/state); screen blanks but
> system hangs.
>
> Bisection reveals that the problem commit has hash:
> 295f00042aaf6b553b5f37348f89bab463d4a469.

That would be:

author	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
	Fri, 2 Jan 2009 15:12:48 +0000 (16:12 +0100)
committer	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
	Fri, 2 Jan 2009 15:12:48 +0000 (16:12 +0100)
commit	295f00042aaf6b553b5f37348f89bab463d4a469
tree	cbd56955f148f0e175d5b6b779c2888bf2645382
parent	ebdab07dad3d3a008e519b0a028e1e1ad5ecaef0

ide: don't execute the next queued command from the hard-IRQ context (v2)

CCing Bart and linux-ide.
