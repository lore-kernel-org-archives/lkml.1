Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbXFATg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbXFATg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763357AbXFATgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:36:15 -0400
Received: from xes-mad.com ([216.165.139.214]:40877 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762947AbXFATgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:36:13 -0400
X-Greylist: delayed 2154 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 15:36:13 EDT
Message-ID: <46606CBA.9020904@xes-inc.com>
Date: Fri, 01 Jun 2007 14:00:10 -0500
From: Andrew Kilkenny <akilkenny@xes-inc.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: khollis@bitgate.com
CC: linux-standards@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Watchdog API Update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patched from 2.6.16

Included are patches for the Watchdog API. This API is already AD HOC 
according to the documentation, so the update is not expected to meet 
much opposition.

The patch/api update adds support for enabling watchdog monitoring 
directly via the kernel driver. It appears some drivers do this on their 
own, while others implement the api, dictating that userspace programs 
manage the watchdog. This includes adding both the ability for userspace 
to enable/disable the feature, and to compile in the feature to be 
enabled automatically at boot.

The Patch file includes diffs from watchdog.h, the watchdog.txt 
documentation, and a KConfig file.

I am unsure on the licensing information. The header file only mentions 
it was derived from Ken's original code. GPL information is absent, 
along with dates. In fact, I am unsure where the copyright belongs, if 
it defaults to Berkshire PC, if it must be GPL, and the like. Guidance 
will be greatly appreciated, especially if (absent a GPL declaration) I 
need permission to handle this code.
