Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZFGJ4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZFGJ4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZFGJ4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:56:35 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63160 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZFGJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nCjTGJ14/0XX50Y9UY935fTddXwthf6CIjoIbJbYvSNp57ssEopX2RPezaSBikP6LW
         OMNlDSynqmHrXL2iBKCxwg+y0FN6utdpL2HKd2twIzfIB2vHFesSYT3Ga2gfqOHl/zoH
         iaKJ46YX8H52uDe86SJbzBku98ibJLKRUEY/w=
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1244367815.26071.4.camel@johannes.local>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
	 <1244326943.12159.5.camel@localhost>  <1244334102.16810.3.camel@localhost>
	 <1244367815.26071.4.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 12:54:15 +0300
Message-Id: <1244368455.22643.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 11:43 +0200, Johannes Berg wrote:
> On Sun, 2009-06-07 at 03:21 +0300, Maxim Levitsky wrote:
> 
> > > Is this source for same firmware that was closed?
> 
> Yes, but it was compiled differently afaik so you won't arrive at the
> same binary.
> 
> > > Will AP mode work in future?
> 
> Well, not TYPE=AP, but we'll integrate whatever is necessary into one
> firmware, I expect. It shouldn't be very hard given that AP mode really
> works with the TYPE=STA firmware already, almost.
> 
> > What does this mean:
> > 
> > eeprom   : ORIGIN = 0x000000, LENGTH = 1024k
> > 
> > 
> > Does the device have whole 1M of eeprom?
> > What is there?
> 
> The eeprom is mapped there, but I don't think it's 1M, it's just the max
> size of the mapping to the CPUs address space.
Fine, like I expected, but still, I guess there is some 'loader' in
eeprom?



> 
> > Also what is this:
> > 
> > sram     : ORIGIN = 0x100000, LENGTH = 64k
> 
> This is just memory. It's used for buffering frames and dma descriptors
> etc. internally. I want to change the code to do this with the linker
> script rather than manually assigning addresses in the source. But if
> you grep for this address you'll find how it's used.
Great.


> 
> > Description says that pram is 32K, but:
> >  
> > pram     : ORIGIN = 0x200000, LENGTH = 16k
> 
> Yeah, we're not exactly sure about this yet, but using 32k definitely
> crashes the device.
Thats fine too.


If there were a documentation too.
Isn't it possible to publish it?

This firmware contains so many 'magic' registers.

Best regards,
	Maxim Levitsky

