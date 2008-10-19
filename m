Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbYJSPlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbYJSPlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 11:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYJSPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 11:41:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:52886 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYJSPlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 11:41:13 -0400
Date: Sun, 19 Oct 2008 09:41:11 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: =?ISO-8859-1?B?Um9nw6lyaW8=?= Brito <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] trivial: fix documentation regarding default io
 scheduler
Message-ID: <20081019094111.671ad48f@bike.lwn.net>
In-Reply-To: <20081019072419.GA21534@ime.usp.br>
References: <20081019072419.GA21534@ime.usp.br>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008 05:24:21 -0200
Rogério Brito <rbrito@ime.usp.br> wrote:

> The current Kconfig.iosched documentation says that the default I/O
> scheduler is the CFQ scheduler, but the default, if nothing is
> changed, is the anticipatory scheduler.

>From Kconfig.iosched:

choice
	prompt "Default I/O scheduler"
	default DEFAULT_CFQ

So the default is, indeed, CFQ.

jon
