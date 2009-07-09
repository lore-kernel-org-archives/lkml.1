Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZGIALL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZGIALL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZGIAK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:10:58 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4306 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZGIAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:10:57 -0400
Subject: Re: fealnx: Fix build breakage -- PR_CONT should be KERN_CONT
From: Joe Perches <joe@perches.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <aday6qyzpo3.fsf@cisco.com>
References: <aday6qyzpo3.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 17:10:47 -0700
Message-Id: <1247098247.25028.41.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 17:05 -0700, Roland Dreier wrote:
> Commit ad361c98 ("Remove multiple KERN_ prefixes from printk formats")
> broke the build for fealnx because it added some "printk(PR_CONT ..."
> calls, when PR_CONT doesn't exist; it should be "printk(KERN_CONT ..."

Sorry, thought I had removed all of those...
Those are the only 3.

