Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZGBS5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZGBS5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZGBS5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:57:36 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:38792 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751345AbZGBS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:57:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eFcoNwkFDQZCrKAIy4B+rMAPFjSpwSN1ATojRBBSuihn3TV0k6BCC+IW8DC4c8sW2AUi/NKHk4Qj4ORSGcyySX2srG35PHWDHem5wjgJtyIhAjUV5+0R8Hwa+w5YeN7aNLhq1V0bE+CWIpj4TFOijEwsbsOJXsg3zeWN1eSYaPU=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: WYK9c_EVM1kGL761tPGNr5WnMHwK06g.X4yB8boDBzh_PKbSKetdVCUfgCIVry.r7KjOLz9RZIHX0oPRaL1cFvv68R_R5Vs.mNhNqArHcoZSNhirYsER0Hy6rhsk5hvOYu416F6UX.j4i.D8Ne9vcGDa.4kqHn0xlrCP959FejXno65UdToXj0Pvin18lPnOp55RUtNT7vTREkbQe7nWWA8Ye45THTwLbit4z8fP9RK_Xw9Xu2zvLYBR_auTYMLzaQfWOx5v6H8xjLov
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [PATCH v2] gpiolib: allow poll(2) on gpio value
Date: Thu, 2 Jul 2009 11:57:33 -0700
User-Agent: KMail/1.9.10
Cc: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>,
       Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org
References: <1244212590-15620-1-git-send-email-dg@emlix.com> <200907011605.31154.david-b@pacbell.net> <359ed6810907020415n39062238q22d1637de2c9383f@mail.gmail.com>
In-Reply-To: <359ed6810907020415n39062238q22d1637de2c9383f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907021157.33250.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 July 2009, Jani Nikula wrote:
> > Looks pretty clean.  Comments from anyone else?
> 
> I'd appreciate a kernel side interface to gpio_setup_irq functionality
> as well; now gpio_export from kernel won't setup support for poll(2)
> nor is there any possibility to do so.

I don't understand what you mean by this... there's no
file descriptor open at that time, so there's no poll()
that could be done.

And kernel-side functionality can just use existing
interfaces to do whatever it likes...

