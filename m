Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbXDKOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbXDKOR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXDKOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:17:58 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:41031 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbXDKOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:17:58 -0400
Date: Wed, 11 Apr 2007 16:15:36 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-Id: <20070411161536.926d79e1.dada1@cosmosbay.com>
In-Reply-To: <461CCD94.6010507@ru.mvista.com>
References: <461A4C1E.3070309@ru.mvista.com>
	<20070410102111.923b92a9.dada1@cosmosbay.com>
	<461CCD94.6010507@ru.mvista.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 15:59:16 +0400
Maxim Uvarov <muvarov@ru.mvista.com> wrote:

> Patch adds Process Performance Statistics.
> It make available to the user the following 
> new per-process (thread) performance statistics:
>    * Involuntary Context Switches
>    * Voluntary Context Switches
>    * Number of system calls
>    
> This data is useful for detecting hyperactivity 
> patterns between processes.

Your description is not very clear about the semantic of your stats.

You currently returns stats only for thread(s) (not process as you claimed)

Please check kernel/sys.c:k_getrusage() to see how getrusage() has to sum *lot* of individual fields to get precise process numbers (even counting stats for dead threads)

