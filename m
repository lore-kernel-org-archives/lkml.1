Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbYEHQXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbYEHQXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYEHQXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:23:45 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:34702 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYEHQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:23:44 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH/RFC] stop_machine: make stop_machine_run more virtualization friendly
Date: Thu, 8 May 2008 18:23:35 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
References: <200805081520.38310.borntraeger@de.ibm.com> <200805081641.20572.borntraeger@de.ibm.com> <48231518.9010209@goop.org>
In-Reply-To: <48231518.9010209@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081823.35696.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 8. Mai 2008 schrieb Jeremy Fitzhardinge:
> > Sorry, forgot to mention. Its kvm.git from 2 days ago on s390.
> >   
> 
> And on s390 cpu_relax yields the vcpu?  That's not common behaviour 
> across architectures.


Yes, cpu_relax on s390 calls diagnose 44. Diagnose 44 translates to yield on 
z/VM and LPAR. Guessing from the number of the diagnose, I think it was used 
on z/VM for timeslice yielding long before Linux came to s390.
