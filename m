Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbYEHOlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbYEHOlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbYEHOlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:41:32 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:31205 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYEHOlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:41:31 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH/RFC] stop_machine: make stop_machine_run more virtualization friendly
Date: Thu, 8 May 2008 16:41:20 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
References: <200805081520.38310.borntraeger@de.ibm.com> <48230137.9090705@goop.org>
In-Reply-To: <48230137.9090705@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081641.20572.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. Mai 2008 schrieb Jeremy Fitzhardinge:
> Christian Borntraeger wrote:
> > On kvm I have seen some rare hangs in stop_machine when I used more guest
> > cpus than hosts cpus. e.g. 32 guest cpus on 1 host cpu triggered the
> > hang quite often. I could also reproduce the problem on a 4 way z/VM host 
with 
> > a 64 way guest.
> >   
> 
> I think that's one of those "don't do that then" cases ;)

I really like 64 guest cpus as a good testcase for all kind of things. 

> 
> I think x86 (at least) is now using ticket locks, which is fair.  Which 
> kernel are you seeing this problem on?

Sorry, forgot to mention. Its kvm.git from 2 days ago on s390.
 
