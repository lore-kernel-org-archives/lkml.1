Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYHUU2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYHUU2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYHUU2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:28:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:51955 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751957AbYHUU23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:28:29 -0400
From: Michal Hocko <mhocko@suse.cz>
Organization: SUSE Linux s.r.o
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: How do I raise the priority of one thread in a multi-threaded process?
Date: Thu, 21 Aug 2008 14:28:27 -0600
User-Agent: KMail/1.9.9
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0808211414220.14466-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808211414220.14466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211428.27524.mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 12:58:46 pm Alan Stern wrote:
> Can anyone tell me how to raise the priority of one thread in a
> multi-threaded process (using the pthreads library)?  Neither nice(2)
> nor setpriority(2) is appropriate since they affect the priority of an
> entire process rather than a single thread.

Isn't pthread_setschedprio, what you are looking for?

>
> Thanks,
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
