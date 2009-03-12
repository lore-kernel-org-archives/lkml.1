Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZCLJYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZCLJYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZCLJYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:24:43 -0400
Received: from n23a.bullet.mail.mud.yahoo.com ([68.142.207.189]:35979 "HELO
	n23a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751730AbZCLJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:24:42 -0400
X-Yahoo-Newman-Id: 106362.25496.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OrffFt80J4GCoHipJi8dgl7/MWGJRPSmBt2xybrFqMzEeIxZrjBbHUtYheQyL4C4vAs3fCOD+jYgbB2XOJPB+Wbovq/73b2Zrzs3BbR65kE/7JMV9sxqsJWP73811T2+/1y6QHRJb9qa9PySz90QYK/fD55WK1ZGXSB7kGzoZMg=  ;
X-YMail-OSG: j8R7ZoQVM1mUBwztbdjC_vbgDzr4iwcA95.plpsfV6us5fMpDxtrT_VO5TQQLCEVEkzJeh1lw5_Qcau3r8ConKQNmE6.L.ZBbXErlve5BpFaT3rnF9mD6HKYz30uTo2a2BQT.3VJyIulL76lqOIMXimMAoBJv7gieyn5xU2FtkeCLc9ZaJWuRkZivmy0
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 3/7] mmc_spi: adjust for delayed data token response
Date: Thu, 12 Mar 2009 01:24:37 -0800
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111345.33154.david-b@pacbell.net> <200903120920.06935.wolfgang.mues@auerswald.de>
In-Reply-To: <200903120920.06935.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903120224.38260.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Wolfgang Mües wrote:
> David,
> Am Mittwoch, 11. März 2009 schrieb David Brownell:
> > All hardware needs some bits to send binary data!!
> >
> > Do you mean "which don't send byte-aligned responses,
> > contrary to MMC/SD/SDIO specifications"?
> 
> No. The specification states that the response from the card after a whole 
> data block is received is IMMEDIATELY, with 0 bits delay. Not every card is 
> able to do this all the time.
> 
> My comment is a little bit missleading, yes.

Well, aligned to zero bytes is the same as "immediately".  ;)

And that description matches up with your other patch.  But
either way, the comment was confusing.

- Dave


