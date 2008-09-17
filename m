Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYIQN3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYIQN3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYIQN3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:29:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:3876 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYIQN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rm57pXbekZkx9tfusBNB1iwatEYstdb2XGfn5ce6V7RsyMOOzg8Z53+8KpE9viSwjf
         TnY40BxHHRNqYGVq9FQFvB/QriKAezzOxoMvggKSXfAVzAbFjKcJrUYTfolC1SFB6dPK
         R1AD0VljrwsAcnPwQqxPZ4Q4V+4hVCxufep4w=
Date: Wed, 17 Sep 2008 17:29:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: j_kernel@hoblitt.com, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917132904.GB7309@lenovo>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo> <20080917092058.GB23209@hoblitt.com> <20080917125950.GA7309@lenovo> <20080917131306.GB20626@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917131306.GB20626@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Sep 17, 2008 at 03:13:06PM +0200]
| 
| > Evetually nmi_watchdog=2 does work right? Though it's not good that 
| > we've got 8259 spurious interrupt. Hmm...
| 
| well, nmi_watchdog=2 changes the layout of clockevent devices and easily 
| switches the system into non-highres non-dynticks mode. So it can hide 
| bugs.
| 
| 	Ingo
| 

and it does since we have nmi stuck on lapics. Still investigating.

		- Cyrill -
