Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZCBWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZCBWlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZCBWlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:41:05 -0500
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:32932 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754356AbZCBWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:41:04 -0500
X-Yahoo-Newman-Id: 261226.19180.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iN5XeyFnaBEvB3OQQbhDKGhHFDvXIL5GXorRQYErkEqym4310BGCOD+AArxfGeAOheR80rSQjlsaGXhpuP9XVOCbP/twysIcBwK0SB2aD/EvJTyE3dmNpJkO3TMfdR59DgmFFluqelDolp9L7ZirW+dtuJBvKcRcIrNQG5YM/j0=  ;
X-YMail-OSG: PDxIxewVM1nh152OIO6sNfpbVmXpNRMIhPgBLk5euiWWRnvklYpYdvqZtuIkKr_tjq.sCJ68IJ6vJLmNE72xZ1On_qzbK2O2rB3aH2jdX3qYTB043yJOVpEhDbjbo2N8IPNw6g.dHyVkePnvRUxJL5IoXYF_sfasbj.uP1N_7Vr8VBre37VXZtP4dCgY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 14:40:58 -0800
User-Agent: KMail/1.9.10
Cc: dbrownell@users.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021409.21344.david-b@pacbell.net> <1236032371.5330.1654.camel@laptop>
In-Reply-To: <1236032371.5330.1654.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021440.58712.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> I state that every !IRQF_DISABLED usage is a bug, either
> due to broken hardware or broken drivers.

That's a novel position.  You do realize that removing that
capability breaks drivers?

But if that's what is keeping you from fixing the lockdep bug,
why haven't you submitted patches to remove IRQF_DISABLED from
the kernel, and update all the drivers relying on IRQs being
enabled when their handlers run?

At least that would get the appropriate level of discussion.

- Dave


