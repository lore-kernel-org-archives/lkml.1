Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYECNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYECNxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYECNxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:53:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:14805 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYECNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=ARKCn9PxfqBRbC6Ux/2hgAasXKtF3YSVMOhSCpbnl+4A2Umk23yaMdw8fMCOsK6ajoq9YVkqySc2aG0NPzn054eXFRBTwBLjlXY3gI7DMjnrbwmoZAlKwXO4f81rfH7QR1L6mu5B9MBmwcbCk+Tw870wSk3pzT2PK5poqx1Zxus=
Subject: Re: i387/FPU init issues...
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: James Courtier-Dutton <James@superbug.co.uk>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <481C452B.10403@superbug.co.uk>
References: <1209810775.6972.37.camel@localhost>
	 <481C452B.10403@superbug.co.uk>
Content-Type: text/plain
Date: Sat, 03 May 2008 09:53:04 -0400
Message-Id: <1209822784.6972.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-05 at 11:57 +0100, James Courtier-Dutton wrote:

> > The only thing that has changed there compared to good version is the
> > last two lines. But that looks sane to me given the struct naming has
> > changed. So i am suspecting the calling path perhaps not setting
> > something or other.
> >
> >   
> My guess would be that the jnc 1f is now wrong.

Do elucidate. The instruction with jnc 1f has always been there.
Is there something as a result of the compiler or the codepath that
makes it now wrong?

cheers,
jamal

