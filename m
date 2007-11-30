Return-Path: <linux-kernel-owner+w=401wt.eu-S1763036AbXK3Fpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763036AbXK3Fpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 00:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXK3Fpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 00:45:42 -0500
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:42426 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751712AbXK3Fpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 00:45:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Fy8pysTTjlQwfuoWt0WQ9rEFINblper1ldaEFeMhqYEiumPqG6ag1W8JlBtJABQJIDLa6f+7kviKANU8gm1bS1dO4LgiDltt+CvMOH8MLKzQKMi+HiurHcAGC7TNdwmimbxnpDQL1VbOo3zs8ttSSNaEu5ZmNx73LO99eioxc7Q=  ;
X-YMail-OSG: i6ppZSUVM1lyy9eFVxGDPWNXhoUXsQAcyDb8OMLa91RMGmE4zXsiDoxSYcc6lBxGGxEMUQC39A--
Date: Fri, 30 Nov 2007 06:45:01 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lucy@keyspan.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071130054500.GB17350@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71> <20071118131130.GA3991@gollum.tnic> <20071126141852.a609cdb6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071126141852.a609cdb6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 02:18:52PM -0800, Andrew Morton wrote:
> On Sun, 18 Nov 2007 14:11:30 +0100
> Borislav Petkov <bbpetkov@yahoo.de> wrote:
> 
> > On Thu, Nov 15, 2007 at 01:10:16PM -0800, Lucy McCoy wrote:

...

> > yes, after testing this i can confirm that this one fixes the NULL ptr
> > problem here so you might want to submit a proper patch to Greg.
> 
> I'll merge revert-keyspan-init-termios-properly.patch soon, but afaik we
> are still awaiting the real fix for this problem?

Hi Andrew,
sorry for the late reply - i was away from the country and couldn't read mail.
Yes, we are still awaiting the real fix afaik but the code fragment above
removes the NULL ptr deref so we should at least merge that. Will prepare a
patch for this later today...

-- 
Regards/Gruﬂ,
    Boris.
