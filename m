Return-Path: <linux-kernel-owner+w=401wt.eu-S965827AbXCFHHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965827AbXCFHHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXCFHHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:07:14 -0500
Received: from server225-han.de-nserver.de ([85.158.176.91]:41168 "EHLO
	server225-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965827AbXCFHHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:07:12 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 02:07:12 EST
Message-ID: <45ED11DE.4080304@codemercs.com>
Date: Tue, 06 Mar 2007 08:01:50 +0100
From: Robert Marquardt <marquardt@codemercs.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Li Yu <raise.sail@gmail.com>, Vincent Legoll <vincentlegoll@gmail.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver
 Interface 0.5.0
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-User-Auth: Auth by marquardt@codemercs.com through 87.187.29.211
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:

> In addition to that, as I stated in some previous e-mail, I am currently 
> working on new 'hidraw' interface, which will provide more flexibility to 
> userland applications willing to operate on raw HID data, than they 
> currently have with hiddev.

I do not know too much about the Linux innards, but my opinion is that 
the HID API to userland should be the bare reports. Windows is handling 
it that way for a good reason. Far too many HID devices have either 
non-informative descriptors (declaring a byte array report) or declaring 
a report which does not match the data contained. Parsing a report is 
definitely a userland job.

-- 
--------------------------------------
Code Mercenaries
Hard- und Software GmbH
Karl-Marx-Str. 147a
12529 Schönefeld OT Grossziethen
Germany

Tel: x49-3379-2050920
Fax: x49-3379-2050930

HRB 16007 Potsdam
Geschäftsführer: Guido Körber, Christian Lucht
