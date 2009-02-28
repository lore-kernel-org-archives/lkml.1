Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZB1UUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZB1UUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZB1UT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:19:58 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:22197 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753261AbZB1UT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:19:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5csqxrLfCYhU6fJqf/ORHKRLsftSORDWYaFK188ZTtyGwGtNw+pHsKNSq8vOnszGJD6yqeOuWGSdW+QwFlsFQ1DqM+valpS1f15LLPXUgbr8h4Fc64zubzSEhqXV8JuoR2MXXRRDgeRNhp3FyNjn879RRLmxpETQ9BHcbYD1ytA=  ;
X-YMail-OSG: purL78cVM1kMAGh2FOEhknmgeFtxXZvVA1gqvBDuuBoA4qhBK8I7asaqm.jckO_aTo_2KFyawFzqMcB8.OIjCOMeoiFfDXkPNoxENPi.E1bb2LH7uiGLqb_vnP2s9BfGkzE0clsF3xT9NhCqoMghWBzu7oAy1WI6TjEkZwD84Sq58Y6ecMUxhXyfm9YW
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: lockdep and threaded IRQs
Date: Sat, 28 Feb 2009 12:19:53 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902272046.50572.david-b@pacbell.net> <49A92487.3020108@s5r6.in-berlin.de>
In-Reply-To: <49A92487.3020108@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902281219.54200.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Stefan Richter wrote:
> Ah, so there /is/ a threaded IRQ handler implementation in
> the mainline, down in some driver framework...

One that's a bit more powerful than the recent patch
proposal, I'd say, since it chains.

 
> Why don't these drivers simply use <linux/workqueue.h>?

Most do.  In fact, that one *does* ... what's your point?

If I hadn't know that more generic threaded IRQ support
was already on the way, I might have done more with that
particular driver than just massive cleanup.  I stopped
short of some changes that it seemed genirq should obviate
before too long.  As always, more cleanup *could* be done.

- Dave

