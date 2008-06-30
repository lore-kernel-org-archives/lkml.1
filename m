Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbYF3VzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbYF3VzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbYF3Vs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:48:29 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21574 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933800AbYF3Vs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:48:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n3gV7yJl6yKIr6IEIGpRFT065GGAuTNDvXY3OaAaRMaKjAee3ZDwfCiT+M/aqvEFywBle2zoOMMXtswenU9WHqmOD9ZK4NZwLMuIHDFsf+vyAQdhwzUmBeh8zkSp3J6EqD5H2tjT5jyCT9e1tqL8DXzzD2qe6tdcVvwUU6i+jGE=  ;
X-YMail-OSG: 9dcPZ5YVM1l_A9s.a5xfGuXfcKJqc5HKUgUMYJ5C6uhlK.rNnLcS3cxxlJznZxS5Jue7IE.zf0xt9KWnujIfHmMOX2ghUb9tfbr7xYYWu.KS7pqDAESTfv2dwdb8M8rQoMI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>,
       Stefan Becker <Stefan.Becker@nokia.com>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt handlers
Date: Mon, 30 Jun 2008 14:48:24 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.44L0.0806301728220.13119-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806301728220.13119-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806301448.24412.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008, Alan Stern wrote:
> 
> > How about this one instead?  I think it's probably almost midnight
> > where Stefan is, so I'd not expect Stefan to have an updated
> > patch very soon ... :)
> 
> It certainly looks right.  We'll let Stefan test it.

Why don't we go with the version Stefan just sent, courtesy of
the rain which was keeping him awake ... he tested it, it works
vs just "obviously correct".

- Dave


