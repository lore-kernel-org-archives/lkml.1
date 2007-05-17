Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbXEQOox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbXEQOox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXEQOoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:44:44 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48897 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbXEQOon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:44:43 -0400
Date: Thu, 17 May 2007 16:44:39 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Chris Malton <chrism@cjsoftuk.dyndns.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Saitek USB Gamer's Keyboard
In-Reply-To: <464C61FF.6080606@cjsoftuk.dyndns.org>
Message-ID: <Pine.LNX.4.64.0705171641400.27422@twin.jikos.cz>
References: <464C61FF.6080606@cjsoftuk.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Chris Malton wrote:

> I have been working on this device for a while, and have come up with 
> the following: The protocol is simple:
> ???? 52 70 ?? ?? ??
> ??
> KC 1 [DOWN]
> ?? ?? 52 70 ?? ?? ??

Chris,

is this device a 0x04f2/0x0418? If so, I have already written a patch 
which adds proper mapping of these keys into input events (also see ticket 
#7352 on bugzilla.kernel.org). This patch is queued for next round of 
mainline merge.

-- 
Jiri Kosina
