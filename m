Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbYKVM7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbYKVM7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYKVM7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:59:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36910 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628AbYKVM7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:59:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: Some FTRACE related question
Date: Sat, 22 Nov 2008 13:59:24 +0100
User-Agent: KMail/1.9.9
Cc: "Steven Rostedt" <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
In-Reply-To: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811221359.24808.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of November 2008, Peter Teoh wrote:
> Q1:   how to use ftrace to ftrace itself?   (i would like to see some
> ftrace-triggered flow)   In view of the following patch:
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-11/msg03745.html
> 
> Is it to prevent this from being possible?

I can't really answer this, sorry.

> Q2:   how to ftrace s2ram and resume?   I attempted to do it, but the
> trace output is always filled with "resume" related functions when it
> started up, which is only logical.

The tracing is disabled during suspend/resume, so you can't.

Thanks,
Rafael
