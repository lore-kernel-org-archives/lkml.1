Return-Path: <linux-kernel-owner+w=401wt.eu-S964837AbXH3TBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbXH3TBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933096AbXH3TAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:00:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52653 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbXH3TAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:00:51 -0400
Date: Thu, 30 Aug 2007 21:00:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Thomas Bleher <ThomasBleher@gmx.de>
cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org, akpm@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version2 Smack: Simplified Mandatory Access Control
 Kernel
In-Reply-To: <20070827215954.GA5979@thorium2.jmh.mhn.de>
Message-ID: <Pine.LNX.4.64.0708302059270.24730@fbirervta.pbzchgretzou.qr>
References: <46D0FF17.4020103@schaufler-ca.com> <20070827215954.GA5979@thorium2.jmh.mhn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 27 2007 23:59, Thomas Bleher wrote:

>> +       for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
>> +               if (*++cp == '\0')
>> +                       break;
>> +               if (sscanf(cp, "%14s %30s\n", name, target) != 2) {
>> +                       printk("%s:%d bad scan\n",
>> +                               __func__, __LINE__);
>
>Leftover debugging printk? Otherwise, a level would be nice.

Or even pr_debug.

(pr_debug("%s...

>> +	static struct tree_descr smack_files[] = {

Hey, can we make this const, if it does not change at runtime?


	Jan
-- 
