Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbZDHSIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbZDHSIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZDHSIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:08:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36401 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbZDHSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:08:08 -0400
Date: Wed, 8 Apr 2009 19:09:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ed Schouten <ed@FreeBSD.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Inconsistency between PTY read() return values
Message-ID: <20090408190916.0c213aba@lxorguk.ukuu.org.uk>
In-Reply-To: <20090408175603.GI32098@hoeg.nl>
References: <20090408143631.GH32098@hoeg.nl>
	<20090408174716.6474af70@lxorguk.ukuu.org.uk>
	<20090408175603.GI32098@hoeg.nl>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 19:56:03 +0200
Ed Schouten <ed@FreeBSD.org> wrote:

> Hi Alan,
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > I would argue that TTYs do behave this way. We treat the disconnect as a
> > hang up event. BSD sees it as EOF, Linux as hangup.
> 
> Would you mind explaining me the difference? I thought a modem
> disconnect implies an end-of-file condition? 

A modem disconnect is a hang up which is quite different to an EOF and is
effectively a security barrier as well (existing users of the tty port
lose access to it aka revoke())
