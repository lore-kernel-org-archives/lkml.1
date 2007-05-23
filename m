Return-Path: <linux-kernel-owner+w=401wt.eu-S1766013AbXEWM35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766013AbXEWM35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXEWM3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:29:50 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55803 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755961AbXEWM3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:29:49 -0400
Message-ID: <46543163.1020607@aitel.hist.no>
Date: Wed, 23 May 2007 14:19:47 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <1179792587.32247.769.camel@localhost.localdomain>	 <200705220839.04773.jbarnes@virtuousgeek.org> <1179876398.32247.885.camel@localhost.localdomain>
In-Reply-To: <1179876398.32247.885.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2007-05-22 at 08:39 -0700, Jesse Barnes wrote:
>   
>> The current code does its best to figure out what modes are available and 
>> tries to pick a good one for each display.  It sounds like you're mainly 
>> concerned with the actual mode picking, not the mode and output detection 
>> and enumeration?  If so, that's a pretty easy change to make.  But if 
>> you're also worried about the kernel building mode lists, then we'll have 
>> bigger changes to make...
>>     
>
> I'm worried that the EDID we get from the monitor is bogus and needs to
> be overriden.
>   
How often do that happen?

There is the alternate solution of assuming that EDID is correct,
and provide an override when it isn't. So anyone with a good monitor
get a nice display by default.  Those with a defective lying monitor
may have to add a "resolution=640x480" parameter to their
kernel command line to get out of the black screen modus.
This shifts the bother to those with a bad monitor, who then are
free to get pissed off at their monitor vendor . . .

Helge Hafting
