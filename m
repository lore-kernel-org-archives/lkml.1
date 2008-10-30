Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYJ3RGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYJ3RGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYJ3RGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:06:05 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:40234 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756279AbYJ3RGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:06:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tcCr6H6hbWt/LBcTolDuEU+lnzOvE7zVj+NXkEIHJWK7LxKJAaMggA2sNjI2urKugXFZcfPb8qqls+FpaK9J93zD9wi0bAWIY16+ILenSQd2p4PNO74xIuM/hFQXSblIRu+2vqXCpjlaFayrwvdny3v9CGaLYgXQ9CayzcacB2U=  ;
X-YMail-OSG: iAqfVFwVM1kyScw.QrtFDxFz6E5NRwLrDFnnE_fMe2J.THnwVRVUXvZK1noHySeEeaT4T.AjJvpczGha95GO5mnqNIJCR4m4DPe3voTNCl3hFuJpo2EQyBX0EDfyyb0g3_Y-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nate Case <ncase@xes-inc.com>
Subject: Re: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
Date: Thu, 30 Oct 2008 10:06:01 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1225301377-9092-1-git-send-email-ncase@xes-inc.com> <200810300116.33131.david-b@pacbell.net> <1225379144.27415.111.camel@localhost.localdomain>
In-Reply-To: <1225379144.27415.111.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810301006.01689.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008, Nate Case wrote:
> But, based on what you're saying, it sounds like I should rework this
> patch to make a 'ds1307_reset_regs()' function that would be called both
> when the registers are found to be in a bogus state (at least for the
> m41t00), and also anytime we restart the oscillator for all chips?

I think that'd be good, yes.

You'r sure that the m41t00 oscillator keeps going in this odd
state you're defending against, and it wouldn't suffice to have
the time and date registers initialized when restarting the
oscillator?

- Dave

