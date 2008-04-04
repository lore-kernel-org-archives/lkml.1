Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYDDPiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYDDPiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYDDPiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:38:17 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:30804 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYDDPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kQUjTclzqIyaT1psN93Eoa2AhT7AlDhTt9YOQ0582JozHtVfFNJKvJ2QJUeDs7SoW7y8aEAlJ2FxJqJttHQvh/UcypxzsAKWwAfduAZBz2PzuzMW4sxo88rgJzOPwVcVDQ5bKHZQUE+HhBr0/x6ypSSUQO4JJr1bJZfXdIt85oc=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
Date: Fri, 4 Apr 2008 21:02:01 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yanko Kaneti <yaneti@declera.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.KN.1DW9HB@albercik> <alpine.LFD.1.10.0804041531001.3224@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804041531001.3224@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804042102.01555.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008 07:03:50 pm Thomas Gleixner wrote:
> On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> 
> Yes, it is. The revert of the patch which caused that is queued for
> todays push to Linus.
> 
> Thanks,
> 
> 	tglx
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10382
> > Subject		: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
> > Submitter	: Yanko Kaneti <yaneti@declera.com>
> > Date		: 2008-04-02 10:59 (2 days old)
> > References	: http://lkml.org/lkml/2008/4/2/210
> > Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 		  Balaji Rao <balajirrao@gmail.com>
> > 
> > 
> 
Hi tglx,

I think the following commit should also be reverted. 

commit 37a47db8d7f0f38dac5acf5a13abbc8f401707fa
Author: Balaji Rao <balajirrao@gmail.com>
Date:   Wed Jan 30 13:30:03 2008 +0100

    x86: assign IRQs to HPET timers, fix

-- 
regards,
Balaji Rao
