Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYAPVTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYAPVTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYAPVTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:19:00 -0500
Received: from mail.queued.net ([207.210.101.209]:3543 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYAPVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:19:00 -0500
Date: Wed, 16 Jan 2008 16:19:12 -0500
From: Andres Salomon <dilinger@queued.net>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080116161912.7b449466@ephemeral>
In-Reply-To: <478E4267.7020509@i4.informatik.rwth-aachen.de>
References: <478E4267.7020509@i4.informatik.rwth-aachen.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 18:44:07 +0100
Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:

> Hi,
> 
> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
> and it hangs during boot:
> 
> [   12.689971] NET: Registered protocol family 16
> [   12.703329] geode-mfgpt:  Registered timer 0
> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
> 


What BIOS are you using?  It's possible that our detection code is
failing to detect in-use timers.
