Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYLPPZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYLPPZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbYLPPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:25:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55258 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928AbYLPPZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:25:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Tue, 16 Dec 2008 16:25:37 +0100
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <gi247o$iog$1@ger.gmane.org> <200812160002.43427.rjw@sisk.pl> <gi7433$m5f$1@ger.gmane.org>
In-Reply-To: <gi7433$m5f$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161625.37318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 of December 2008, Brian J. Murrell wrote:
> On Tue, 16 Dec 2008 00:02:43 +0100, Rafael J. Wysocki wrote:
> > 
> > No, most probably your graphics adapter is not handled correctly in this
> > case, because it needs some special user space quirks, which are done by
> > hald that is not running.
> 
> Hrm.  OK.
>  
> > You can try to use the s2ram binary (http://en.opensuse.org/s2ram) to
> > work around this issue.
> 
> That sounds like I am setting for something less than optimal.  Is that 
> the case?  Why would I want to use what I've been trying to get working 
> rather than s2ram?  Maybe put another way, why isn't everyone using s2ram?

Because the hal-driven whitelist allows us to match systems in a more detailed
way.  If your system is in the s2ram whitelist already and works with it, there
shouldn't be any difference.

Still, I was only considering that as a debugging aid in your case, because
s2ram works in the minimal configuration, while hald doesn't.

> Ultimately I'm going to want to be able to suspend as well as hibernate, 
> for whatever that's worth.
> 
> > Anyway, if you suspend for the second time from this state, does it
> > resume?
> 
> No.  It fails just as miserably.  :-(

That's a bit of new information.

What's the list of modules loaded in the minimal configuration?

Rafael
