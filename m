Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYAOVHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYAOVHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYAOVHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:07:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:59313 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYAOVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=c0UY9whmRJqrrQ6A0GGn1IjV+qSlyxDLvG/7Fyb6Ea6jRxNvVTB2AEt3M2xdvYg+4wPzRanO1DIRq0Qg16HHyTP0adhxSjJpp5/L1vBktYng0fEatZ81+JMtWPqjmM/WaazmOfi8WByp+t2r3z90FsrrvpNJNXEQYZh1TdUb3JI=
Date: Tue, 15 Jan 2008 16:07:32 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Micah Parrish <micah.parrish@hp.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Chiang, Alexander" <achiang@hp.com>
Subject: Re: [PATCH, v2] Input: tell mousedev to handle HP remote console
	virtual mouse using absolute coordinates
Message-ID: <20080115160440.ZZRA012@mailhub.coreip.homeip.net>
References: <1200357956.6630.24.camel@strongbad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200357956.6630.24.camel@strongbad>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micah,

On Mon, Jan 14, 2008 at 05:45:56PM -0700, Micah Parrish wrote:
> The HP Integrated Remote Console Virtual Mouse, which is standard equipment 
> on all Proliant and Integrity servers, produces absolute coordinates 
> instead of relative coordinates.  This is done to synchronize the 
> position of the mouse cursor on the client desktop with the mouse 
> cursor position on the server.  Mousedev is not designed to pass 
> those absolute events directly to X, but it can translate them 
> into relative movements.  It currently does this for tablet like devices 
> and touchpads.  This patch tells mousedev to also enable this function for
> the HP virtual mouse.  This patch is narrower in scope than my previous
> patch of the same name, which enabled abs-to-rel translation for all 
> devices with ABS_X, ABS_Y, and BTN_LEFT.
>

I thought it over and I decided to include the previous version of the
patch (the one that does not have venor/pid restriction), since it looks
like Xen people might need it too.

It should be included in the next pull request to Linus.

Sorry for the delays.

-- 
Dmitry

