Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXJIVoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXJIVoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXJIVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:44:00 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:20385 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751105AbXJIVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:43:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rtzbHM0W1lPcFcmvG/szgLg4NRPE9is1DUivcOrbKyfV8IA9ru0PilQTxdE8GiAltLFbQWvSMjPbzv35lCciX5w1Ek1N/VJHlduRWYl1jHWEwaTgz5Nq1JCpob0ikvfb912SjRm5E30Grd/mGpso9/bPeC/MSTEWLcG8LhFswts=  ;
X-YMail-OSG: Fi0q7HAVM1kI4D8Y.FKOwC2dvpqvie5Oy1jx7OfZrWQ306eAvdEbtcGybLHWJNL5RR_Mg5q2hQ--
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
Date: Tue, 9 Oct 2007 14:43:54 -0700
User-Agent: KMail/1.9.6
Cc: stern@rowland.harvard.edu, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
References: <20071009173925.GA6062@kroah.com> <Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org> <20071009.142719.68041626.davem@davemloft.net>
In-Reply-To: <20071009.142719.68041626.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091443.54998.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007, David Miller wrote:
> Are we sure that this is the only event that causes the conflicts between
> the EHCI and it's companion virtual OHCI/UHCI host(s)?

It's the event which can cause trouble when EHCI starts up
after OHCI/UHCI (rather than before it).

The other event is setting the OWNER bit, which clearly
has not caused trouble.

Does it resolve the problem you observed?

- Dave

