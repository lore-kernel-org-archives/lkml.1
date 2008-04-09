Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYDIXKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYDIXKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 19:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYDIXJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 19:09:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYDIXJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 19:09:56 -0400
Date: Wed, 9 Apr 2008 19:07:34 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: sukadev@us.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] add the clone64() and unshare64() syscalls
Message-ID: <20080409230733.GR20478@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080409222611.GA28087@us.ibm.com> <20080409223459.GC28267@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409223459.GC28267@us.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 03:34:59PM -0700, sukadev@us.ibm.com wrote:
> From: Cedric Le Goater <clg@fr.ibm.com>
> Subject: [PATCH 3/3] add the clone64() and unshare64() syscalls
> 
> This patch adds 2 new syscalls :
> 
>      long sys_clone64(unsigned long flags_high, unsigned long flags_low,
> 		unsigned long newsp);
> 
>      long sys_unshare64(unsigned long flags_high, unsigned long flags_low);

Can you explain why are you adding it for 64-bit arches too?  unsigned long
is there already 64-bit, and both sys_clone and sys_unshare have unsigned
long flags, rather than unsigned int.

	Jakub
