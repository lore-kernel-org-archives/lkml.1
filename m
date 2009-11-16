Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZKPRBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZKPRBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZKPRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:01:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44756 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZKPRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qiXF1Qu22z961WeSgGwobBtGWDU3YZFTYoumYiABSsy5ylNxjHyOIn8xtlq6c8UhVz
         ofpcLvOpyevOWCaXZ5TEcsHATR0JFVE1y5n/M+g+39EVqWOQtoezuDmMjPV7STZkWdL5
         JGeFLE+38ihmP4qYb3JLJw75LlbyX2UWpefaQ=
Date: Mon, 16 Nov 2009 09:01:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: fix wrong synaptics detection in
	psmouse_extensions()
Message-ID: <20091116170151.GA24026@core.coreip.homeip.net>
References: <alpine.LSU.2.00.0911161245570.15039@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911161245570.15039@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:51:30PM +0100, Jiri Kosina wrote:
> Commit b7802c5c1ea ("Input: psmouse - use boolean type") caused the 
> synaptics_hardware variable to be completely useless, as it is constantly 
> set to 'true' throughout the whole psmouse_extensions(). This was caused 
> by the following hunk in the commit in question
> 
> 	-       int synaptics_hardware = 0;
> 	+       bool synaptics_hardware = true;
> 
> which is wrong. Fix that up.

Hmm, not sure what I was thinnking at that time but it is obviously I
should have stayed away form tehe keyboard...

Applied, thank you Jiri.

-- 
Dmitry
