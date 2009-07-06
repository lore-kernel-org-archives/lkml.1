Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZGFR2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZGFR2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGFR2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:28:31 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:57703 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZGFR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:28:30 -0400
Message-ID: <4A523438.6030506@davidnewall.com>
Date: Tue, 07 Jul 2009 02:58:24 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jeff Arnold <jbarnold@ksplice.com>, linux-kernel@vger.kernel.org,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com,
       nelhage@ksplice.com, price@ksplice.com, geofft@ksplice.com
Subject: Re: Ksplice updates for Ubuntu 9.04 Jaunty
References: <alpine.DEB.1.10.0906250451210.22588@vinegar-pot.mit.edu> <20090630063152.GC1351@ucw.cz> <alpine.DEB.1.10.0907010909250.26501@vinegar-pot.mit.edu> <20090702213823.GB1485@ucw.cz> <alpine.DEB.1.10.0907021740140.8890@vinegar-pot.mit.edu> <20090705184710.GB17910@elf.ucw.cz>
In-Reply-To: <20090705184710.GB17910@elf.ucw.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> I did not say "unimportant patches". I said simple patches.
>
> Lets say something adds field to task_struct. Can you handle that?
>   

By co-incidence, a similar discussion took place on another mailing list
last week, and the answer was that yes, Ksplice can handle it.  From my
reading of the Ksplice paper (http://www.ksplice.com/paper), I think a
shadow structure is created to hold the new field.  Code that accesses
the new field, which ipso facto is part of the patch, is modified to use
the shadow structure; the rest of the kernel remains unaltered.
