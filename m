Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbXIUTnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbXIUTnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762249AbXIUTnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:43:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:22776 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762176AbXIUTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mTAvnL1DwJlZ1B9F8peiI16aclMM7XiIrynt7T5EaUOxwC1EolPDihYae6VEsaZNcFBb+VNnimtfn83oTctluyi6nwSBZNR2A00NVCmazAyJGNt7GkPFSxbrRrE9Vg9xUvax+LqlODpRKcmaVtT++2/iCugVB68NAEQtEIJY3Oo=
Message-ID: <46F41ED8.3020301@gmail.com>
Date: Fri, 21 Sep 2007 21:43:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu>            <46F3FF9C.7040200@gmail.com> <4109.1190403228@turing-police.cc.vt.edu> <46F41DC0.9060407@gmail.com>
In-Reply-To: <46F41DC0.9060407@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2007 09:38 PM, Jiri Slaby wrote:
> It is rather the other user who adds the page to some other list while being at
> deferred_pages list. Could you try my debug patch
> (http://lkml.org/lkml/2007/9/19/141)?

or the whitespace non-damaged version:
http://www.fi.muni.cz/~xslaby/sklad/pageattr_debug
