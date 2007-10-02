Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbXJBVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbXJBVib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXJBViU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:38:20 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:63403 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXJBViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IphMt0TwvJcYLSq35Uh1k00yEorwRHqMd5PcYLcEC6TbvFKhOcjJCnw1RFlPYrX8VgplG8yLck+GrRBeC6AO/klBHGWdykS4Uq0SkoRa6EiGamPwhMi7sUCM1EyHPN8eyQ7KRf0M041o4KL0z8rKAvFo09sgnEM4Q1ZPIkihEPU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] input: move gameports out of SERIO menu
Date: Tue, 2 Oct 2007 17:38:11 -0400
User-Agent: KMail/1.9.7
Cc: lkml <linux-kernel@vger.kernel.org>, linux-input@atrey.karlin.mff.cuni.cz,
       akpm <akpm@linux-foundation.org>
References: <20071002141225.d503cdbb.randy.dunlap@oracle.com>
In-Reply-To: <20071002141225.d503cdbb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021738.11349.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Tuesday 02 October 2007, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move the gameport support menu out of the SERIO menu and put it
> between touchscreens and misc. devices in the main input layer menu.
> Change it to use menuconfig instead of config.
> 
> Or was it meant to be listed under Hardware I/O ports?
> It sure seems odd there to me.

Yes, they are meant to be under "Hardware I/O" ports. Like serio ports
they represent hardware ports to which devices (such as gamepads or
a joysticks can be connected to).

-- 
Dmitry
