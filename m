Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbXFOSF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbXFOSF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbXFOSFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:05:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:64178 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbXFOSFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,425,1175497200"; 
   d="scan'208";a="257361111"
Message-ID: <4672D4D3.60905@intel.com>
Date: Fri, 15 Jun 2007 11:05:07 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       apw@shadowen.org, jschopp@austin.ibm.com
Subject: Re: coding style
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
In-Reply-To: <4672D246.2040306@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 18:05:08.0843 (UTC) FILETIME=[B5BDC3B0:01C7AF77]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Consider two people, one with tabs as 8 characters and one with tabs as 
> 4 characters.  If person A aligns using a tab plus a space (giving 9 
> characters), then the alignmnet will be all screwed up for person B (who 
> will see 5 characters of alignment).
> 
> The only rule that works (setting aside bad tools) is:
> 
> "use tabs for indents and spaces for alignment"
> 
> If that means you need to use two dozen spaces, then so be it.

it would be awesome if the checkpatch.pl script could distinguish between 
indentation and alignment space usage - this is going to cause major confusion 
with patch submitters.

I personally think that the sentence

   "use tabs for indents and spaces for alignment"

should also be in the CodingStyle document to avoid confusion.

Auke
