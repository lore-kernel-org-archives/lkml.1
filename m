Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYGATVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYGATVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYGATVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:21:40 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:28106 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753140AbYGATVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:21:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Jh856oM1rKEYXJ6jbRa4GO8421USQa4Mliqph/jqiQiVcDphnV5bx1+tjs7MZra0+sz38Zh+71mO8nrAY3M+dOvvB2kT2rWprcMWnYFJebSrjEMbcye5LAjFmN4jEqVQy1wetJAkzZ2/R2wQDvpofVx1X+pJfzHQ2UarNEYC4aE=  ;
X-YMail-OSG: MOYwGcoVM1lXGdUKPHitUoNG9DoiA3Defe2DXA3YK_sTBEmdyRFWPecAMeW9kuwq2PZdYsxMXzzawLEdsM8jLWJWe_RErGYwo2stRhs1XvhRK9dtC_wHaQtTkf_ZCo9tCJk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt handlers
Date: Tue, 1 Jul 2008 12:21:37 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <gregkh@suse.de>, Stefan Becker <Stefan.Becker@nokia.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ext Leonardo Chiquitto <leonardo.lists@gmail.com>
References: <Pine.LNX.4.44L0.0807011456370.6796-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807011456370.6796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807011221.37388.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008, Alan Stern wrote:
> It's surprising that more people haven't experienced this problem and 
> reported it.

Maybe ... I'd update the comment to point out that enabling
lockdep prevents these problems from appearing.  :)


> > Alan and Dave, do you both ack this thing?  I know you've been involved
> > in creating it, just want to get the formal approval :)

Let me reboot a couple machines into their new kernels first...

- Dave
 


