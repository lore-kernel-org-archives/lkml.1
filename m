Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYF1GPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYF1GPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 02:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYF1GPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 02:15:13 -0400
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:26914 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752781AbYF1GPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 02:15:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=JaLnsSQjzji9yDwJ1FRE3jt1LMpOdSbk69Hw2d3sTeRO1FxlpNS67m6R3C93cOWOqcwoVYIq4b/TY4E+RlhgEssZvBnIUm2tm+/K4fb7P4TJs6agxmNrkFLITYqbQAThQiqG1q7R5f5msT0t7bAZ75fYypGoT5VGnsmOLUR1UTM=;
X-YMail-OSG: iUxDCjcVM1lmooBiD_3sgkYadkSMsyD3Ct4h2KKxxXbHWu1l7bC6QdAZvth5lUK8N0G3qP9LfSDK0DWGcZYCm5wJqwb29Qo_Qfw6FWJBeWGXZNO.fW4ScOfSw3jb.12iJw--
Date: Fri, 27 Jun 2008 23:15:06 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
To: Andi Kleen <andi@firstfloor.org>, dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <87r6aip2pi.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <77374.55758.qm@web50103.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:

> dougthompson@xmission.com writes:
> >
> > 2)  I have not yet tackled the de-interleaving of the
> > rank/controller address space into the physical address
> > space of the CPU.  There is nothing fundamentally missing,
> > it is just ending up to be a lot of code, and I'd rather
> > keep it separate for now, esp since it doesn't work yet...
> >
> > 3)  The code depends on a particular i5100 chip select
> > to DIMM mainboard chip select mapping.  This mapping
> > seems obvious to me in order to support dual and single
> > ranked memory, but it is not unique and DIMM labels
> > could be wrong on other mainboards.  There is no way
> > to query this mapping that I know of.
> 
> Since there's a non negligible probability that the output
> of this driver is completely misleading because of (2) and (3)
> and probably (4) too [reporting the wrong DIMMs etc.]
> would it be possible to add some flag to EDAC that 
> warns the user that the output is not fully reliable?\

good idea.

Arthur, could you add some more text to the driver's output, before the call to the
core's output function, doing exactly that? Explaining just what you DO know, and what you don't
know?

doug t

> 
> -Andi (who can just see people replacing the wrong DIMMs and 
> then blaming Linux)
> 
> 


W1DUG
