Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYAFMdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYAFMdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYAFMd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:33:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45243 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYAFMd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:33:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780CA63.50703@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 13:32:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780BBAA.7020908@s5r6.in-berlin.de> <20080106115941.GB2082@does.not.exist>
In-Reply-To: <20080106115941.GB2082@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Jan 06, 2008 at 12:29:46PM +0100, Stefan Richter wrote:
>> Adrian Bunk wrote:
>>> Duplicating the structure in each UI should be an improvement?
>>>
>>> Hardly.
>> What do you mean?
...
> You said:
> "The graphic UIs including menuconfig currently work best for tree-like 
>  dependencies"
> 
> That's true.
> 
> And the dependency graph can't be a tree.
> 
> Currently, defining the ordered tree the UIs present to the user is done 
> _once_ in kconfig.
> 
> Our UIs either show this tree as a tree or go through the tree 
> depth-first and present the options in this order to the user.

All correct.

> And I think your main misunderstanding is that you think the 
> dependencies alone would carry enough information for allowing an UI to 
> present the options in a way not worse than it's currently done - that's 
> simply not true.

No, the dependency relationships alone do not carry enough information.
  I am aware of that.

For example, we certainly want groupings or tags such as "option is
(directly) related to USB hardware", "filesystems related option",
"option is for debugging purposes" etc..  We currently provide hints
like this via the 'menu' keyword.  We also want help texts per option
and per group of options.

However, there is ultimately not a single most logical way to group
options.  There could be groups which would overlap.  The grouping per
'menu' provides only one fixed non-overlapping grouping.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
