Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYKLWvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYKLWvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYKLWuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:50:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbYKLWus convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:50:48 -0500
Date: Wed, 12 Nov 2008 14:50:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       p_gortmaker@yahoo.com,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>
Subject: Re: mmotm 2008-11-06-13-44 uploaded (smc-ultra)
Message-Id: <20081112145029.8034a6f5.akpm@linux-foundation.org>
In-Reply-To: <20081108100911.e475ff0f.randy.dunlap@oracle.com>
References: <200811062144.mA6LiWj8004200@imap1.linux-foundation.org>
	<20081108100911.e475ff0f.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Nov 2008 10:09:11 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 06 Nov 2008 13:44:32 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-11-06-13-44 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.28-rc3:
> 
> 
> mmotm-2008-1106-1344/drivers/net/smc-ultra.c: In function 'ultra_probe1':
> mmotm-2008-1106-1344/drivers/net/smc-ultra.c:254: error: 'mac' undeclared (first use in this function)
> 

Caused by Márton's smc-ultra-get-rid-of-eth%d-message.patch.  Someone
went and removed `mac' from linux-next, and that patch depended upon it.

Márton, I'll drop the patch.  Please redo and resend (against linux-next),
thanks.
