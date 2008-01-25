Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYAYP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYAYP04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYAYP0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:26:50 -0500
Received: from twin.jikos.cz ([213.151.79.26]:40405 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYAYP0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:26:49 -0500
Date: Fri, 25 Jan 2008 16:26:45 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
In-Reply-To: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
Message-ID: <Pine.LNX.4.64.0801251624480.5521@twin.jikos.cz>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Bodo Eggert wrote:

> Enabling this option changes a hard panic on boot errors to a
> soft panic, which does not stop the system completely.
> You can still scroll the screen and read the messages.

Hi Bodo,

if you are willing to put some effort into the ability to scroll the 
console after panic, it might be worthwile to look making the keyboard 
driver work even after panic (i.e. poll the keyboard, rather than relying 
on interrupts).

That has significantly smaller potential of breaking because the system is 
expected to be dead after panic (watchdogs, broken data structures in 
memory, etc).

-- 
Jiri Kosina
