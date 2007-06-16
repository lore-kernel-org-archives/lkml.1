Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758192AbXFPOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbXFPOc6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sat, 16 Jun 2007 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbXFPOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:32:47 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:4697 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbXFPOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lFYT3rVxUU8ejbXJOsSwSfADxiD8TGPmc/IPlTJlU46exc9KjE5LGrm2jwU9qooQRyzlaS0C7EOnHmpzGx80mTGHJYzwv4xRnIxaTCcOFTryWpPNRToWY9jFGagXHohBHE9wVu3ubSLG+NzoyrErA9xO/HIhUJjjTbsSaVPZRfY=
Date: Sat, 16 Jun 2007 18:31:01 +0400
From: gorcunov@gmail.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
        Chris Friesen <cfriesen@nortel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Jan Engelhardt <jengelh@computergmbh.de>,
        dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
        apw@shadowen.org, jschopp@austin.ibm.com
Subject: Re: coding style
Message-ID: <20070616143101.GA6579@cvg>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <4672D4D3.60905@intel.com> <20070615182255.GB8151@cvg> <4673E09F.704@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4673E09F.704@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Stefan Richter - Sat, Jun 16, 2007 at 03:07:43PM +0200]
| Cyrill Gorcunov wrote:
| > There sould be someting making strict rule over alignment (as it done
| > for the tabs size).
| 
| That's impracticable.  Alignment, as it serves readability, cannot be
| covered by a few strict rules.
| -- 
| Stefan Richter
| -=====-=-=== -==- =----
| http://arcgraph.de/sr/
| 

Yes, but C syntax (and grammar) is limited set. And alignmet I'm talking
about may cover the following statements only:

1) Mathematical
2) Logical
3) Function's arguments

Btw, if I see header with definition like
	int foo(int);
instead of
	int foo(int arg);
it makes me nerve ;)

Of course that all concerned to statements being splitted to several lines.
And I think CodingStyle would have recommendations about it. But maybe
I'm just a moron ;)

		Cyrill

