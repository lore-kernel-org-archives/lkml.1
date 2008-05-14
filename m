Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYENUk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYENUk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYENUkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:40:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39499 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYENUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:40:14 -0400
Date: Wed, 14 May 2008 13:39:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc2-mm1 (WARN() build error)
Message-Id: <20080514133919.51be54b9.randy.dunlap@oracle.com>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/

Using WARN() with CONFIG_BUG=n causes:

linux-2.6.26-rc2-mm1/lib/kobject.c: In function 'kobject_add_internal':
linux-2.6.26-rc2-mm1/lib/kobject.c:218: error: implicit declaration of function 'WARN'
make[2]: *** [lib/kobject.o] Error 1

---
~Randy
