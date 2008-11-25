Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYKYXch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYKYXch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYKYXc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:32:27 -0500
Received: from ping.pong.ch ([212.103.71.101]:48229 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYKYXc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:32:27 -0500
X-Greylist: delayed 1118 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 18:32:27 EST
Date: Wed, 26 Nov 2008 00:13:44 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: commit b1ee26b "radeonfb: accelerate imageblit and other
	improvements" freezes system on switching from X to text console
Message-ID: <20081125231344.GA5190@soziologie.ch>
References: <20081125194457.GA4929@soziologie.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125194457.GA4929@soziologie.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 08:44:57PM +0100, Gaudenz Steinlin wrote:
> Hi Ben
> 
> The changes in the commit mentioned in the subject freeze my system when
> changing from X to a text console. The system freezes with a garbled
> display. Reverting this commit fixes the problem.
> 
> The freeze only happens if DRI is enabled in X. It also does not happen
> if I simply switch between different text consoles. 
> 

OK, I searched a bit more and found
http://bugzilla.kernel.org/show_bug.cgi?id=11875 which is possibly
related. I also found the patch Ben proposed to fix this at
http://lkml.org/lkml/2008/11/10/12. Unfortunately this patch did not fix
my problem. 

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
