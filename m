Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZFZKQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZFZKQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZFZKQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:16:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48083 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114AbZFZKQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:16:14 -0400
Date: Fri, 26 Jun 2009 11:17:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626111731.539f963e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626094514.GB12571@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
	<20090626072218.GH14078@elte.hu>
	<20090626101446.114edbe2@lxorguk.ukuu.org.uk>
	<20090626094514.GB12571@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which bit is not clear? We've been continuously 'driverizing' the 

What do you mean by "driverizing". You keep using your made up word but
since nobody else knows what you mean its not productive to have the
discussion using invented terms like that.

> core' drivers (many of the core kernel facilities are not available 
> yet at this early stage), but properly abstracted, function vector 
> driven approaches are still a must.

So like the PPC machine vector ?

> This series of patches increases the mess in that area, and that's a 
> step backwards. It sprinkles the code with a fair amount of 'if 
> (feature_x)' conditions instead of cleanly separating out proper 
> abstractions.

That makes sense
