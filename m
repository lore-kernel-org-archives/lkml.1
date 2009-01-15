Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZAOPft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZAOPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZAOPfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:35:33 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:45616 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754524AbZAOPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:35:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Wq8dWv3VV4nXiW9L5QFHP/mkOYTiTzXfU0Q9RX6In92PqCcaGdxpqlrELYyuCYBqjYPFh/t7GdVatJw/ZiqDXJkEIpQ8ra+kmLwuFsoSRkdyFZf8O1uySy/f9Fg+wImU3kGXdNUW/HklKZq+0ckuZxwhQDFUMQzdhNW3e7Ixcdg=  ;
X-YMail-OSG: JE0WzboVM1mHY8WWYzmJPv5QGFe19Gs56ZYp95VZqOzL.l3mQsQNzxS_1tX7B67AcGidIpgtpjECQxsvB9u_MTQLTCxIk.3.6p94H4zirQqKMx.5sgtGxUdYhEdVKM1VxfpgKa8mQJrskHQEbJYymSD.a8H5vDB1S3pfVVUvd_x2HkBhM7iI9D_au2z3
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc] regulator: add get_status()
Date: Thu, 15 Jan 2009 07:35:29 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <20090115124007.GD2147@sirena.org.uk> <1232023845.4934.368.camel@vega.slimlogic.co.uk>
In-Reply-To: <1232023845.4934.368.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901150735.29883.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Liam Girdwood wrote:
> 
> > > +   /* report regulator status ... most other accessors report
> > > +    * control inputs, this reports results of combining inputs
> > > +    * from Linux (and other sources) with the actual load.
> > > +    */
> > > +   int (*get_status)(struct regulator_dev *);
> > > +
> > 
> > ...this needs kerneldoc adding.
> 
> Please send a separate patch for the kerneldoc as I've already applied.

So that will be the first member of "struct regulator_ops" to
grow kerneldoc ... out of a total of fifteen (now) members.
Hmm...

Maybe I'm not understanding what's meant by "kerneldoc adding".
Perhaps it's nothing more than a sentence resembling "returns
REGULATOR_STATUS_* code or negative errno", and not real
kerneldoc?

- Dave

