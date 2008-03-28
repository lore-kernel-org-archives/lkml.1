Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYC1WbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYC1WbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYC1Wat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:30:49 -0400
Received: from semihalf.com ([206.130.101.55]:37913 "EHLO semihalf.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbYC1Was (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:30:48 -0400
Message-ID: <47ED6BE5.9060807@semihalf.com>
Date: Fri, 28 Mar 2008 23:06:29 +0100
From: Bartlomiej Sieka <tur@semihalf.com>
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Please pull powerpc.git merge branch
References: <18412.58902.189124.391104@cargo.ozlabs.ibm.com>
In-Reply-To: <18412.58902.189124.391104@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Linus,
> 
> I have added another commit to the powerpc.git merge branch, so when
> you do:
> 
> git pull \
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge
> 
> you'll get a fix for a bug where the hardware data breakpoint would
> sometimes fail to trigger on powerpc, if multiple threads put a
> breakpoint on the same address.  The bug has been around for a while
> and Michael Ellerman just found the cause and posted a fix.

Hello Paul,

What about http://patchwork.ozlabs.org/linuxppc/patch?id=17525 ? I don't
see it in the merge branch of your repository, and it would be nice to
get it upstream as it fixes boot problems on some MPC5200-based boards.

Regards,
Bartlomiej
