Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZBDGTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZBDGTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZBDGTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:19:33 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:39403 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZBDGTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:19:32 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
Date: Wed, 4 Feb 2009 07:19:25 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200901301729.30284.borntraeger@de.ibm.com> <200902030948.13519.borntraeger@de.ibm.com> <20090203122847.GG19979@elte.hu>
In-Reply-To: <20090203122847.GG19979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040719.25593.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 03 February 2009 13:28:47 schrieb Ingo Molnar:
> > > +		if (!cpu_active(cpu) {
> >
> > That does not compile...I used the following:
> > 		if (!cpu_active(cpu)) {
>
> Could you please resubmit an updated patch?

Suresh,

can you send the updated patch? After all, its your work and we need your 
Signed-off-by anyway.

You can add my 
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks

Christian
