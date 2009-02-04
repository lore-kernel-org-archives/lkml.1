Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbZBDXqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbZBDXqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZBDXpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:45:54 -0500
Received: from ozlabs.org ([203.10.76.45]:58899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbZBDXpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:45:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Thu, 5 Feb 2009 10:15:46 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, travis@sgi.com, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <20090204213519.GR22608@elte.hu> <20090204134823.8eefa728.akpm@linux-foundation.org>
In-Reply-To: <20090204134823.8eefa728.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051015.47360.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 08:18:23 Andrew Morton wrote:
> I expect that the same argument applies to most of the set_cpus_allowed()
> callsites - they're run by root-only code.  Sure, root can (with
> careful timing) move root's own thread onto the wrong CPU in the middle
> of microcode loading.  In which case root gets to own both pieces.

Sorry, I don't accept this at all.  It's completely reasonable for me to write a tool which clears all tasks off a cpu.  We wrote an API to do it, now we're going to say don't use it?

Yes, it's a pain to fix.  Yes, we should never have been doing it this way in the first place.  But let's not blame the users.

Rusty.
