Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbXEUNwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbXEUNwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXEUNwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:52:38 -0400
Received: from gw.goop.org ([64.81.55.164]:58419 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbXEUNwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:52:37 -0400
Message-ID: <4651A427.4010600@goop.org>
Date: Mon, 21 May 2007 14:52:39 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andi Kleen <ak@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
References: <200705191443.27161.arvidjaar@mail.ru> <20070519133257.GB23370@uranus.ravnborg.org> <200705191555.49376.ak@suse.de> <4651A113.9020300@goop.org> <20070521134828.GA1394@uranus.ravnborg.org>
In-Reply-To: <20070521134828.GA1394@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> There was another patch that removed the __init marker to _fix_ section mismatch errors.
> I have lost the actual mail but I asked the submitter to send me a copy of
> the configuration so I could take a closer look.
> Obviously it was the wrong fix to remove the _init marker.

Hm, I think there were two overlapping patches to address the problem. 
One removed the __init markers, and was a bit of a hack.  Mine
restructured all the functions so that it was all done properly (ie,
init called init; cpuinit called cpuinit).  Looks like both got applied.

    J
