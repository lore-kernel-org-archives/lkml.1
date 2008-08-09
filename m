Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYHIUdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYHIUdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 16:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYHIUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 16:33:10 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42186 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYHIUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 16:33:08 -0400
Message-ID: <489DFF0E.2080802@keyaccess.nl>
Date: Sat, 09 Aug 2008 22:33:18 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Framebuffer drivers that break the boot on systemswithout the
 hardware
References: <489DFACC.6030009@keyaccess.nl>
In-Reply-To: <489DFACC.6030009@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-08-08 22:15, Rene Herman wrote:

> At:
> 
> http://lkml.org/lkml/2008/8/1/96
> 
> Ingo Molnar posted a list of drivers he found to break the boot during 
> testing of randconfig kernels [ ... ]

CONFIG_MDA_CONSOLE is weird. Is that one certain? To have that thing do 
anything other than <zilch> it seems to need RAM at 0xb0000 which not 
really anything other than an MDA/HGA should be puting there.

Then again, you also had VGA16FB among the breakers. Very decidedly 
non-legacy HW or something?

Rene.
