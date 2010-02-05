Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0BEFzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 00:55:17 -0500
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:28863 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752252Ab0BEFzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 00:55:16 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 00:55:16 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=iR8aUqqG8HviDchzEruIeeRjo0pVNKPBEo5y07YINGkBcDY3Kzb/vTCF6HXx0YWd35/tbx0TI2Wb7AvCAYqUzy18K1cUMPEaXIc02TjbfkQ9okCb5b6fNreXDldptr98k89IghmzSQQXwf6WWtWZwttFsYZen8+QY+8J+eID0kk=;
Message-ID: <324607.19392.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: e8hQ41gVM1k1YfL_u0sRAMCbPwdGZCDs1ioywSUroVgYanMisOBnr.IhepNKeDjSckQnbfAVbIx7vQtpWcxkyaXbDyD8HZVm50OnmhXxRnNcVIcxcKRxNiwEoiBjyT9ee4cdtAWFPcPQPH7ZXT0qe7tyyZ2pZJmcmNYVo5GElL.mkIVeEvDD7D_TB5t4Di0Hc8wdpsQ9pFnKGVEQFc.pMHEFuvsL9_f9fxH4brqu.WoT9UvvP4YIHnADqxfxCW7JwO5c4X9sXWBtN.M5pCf.BrjyqLeffqXABxv5ZphmB_uSc_dUlYe6Likd0RMZewydLkh_K6DAMHG.nhnZMXgwSCi8ZqmP0IUv7zAk_aqIU6FRz2ecLdgjPmzbyji1AyiMzZ7ASid8j9lhenLjpA--
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Thu, 4 Feb 2010 21:48:34 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 6/7] edac: mpc85xx fsb ecc
To: dougthompson@xmission.com, Peter Tyser <ptyser@xes-inc.com>
Cc: kolifer@gmail.com, akpm@linux-foundation.org,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1265304134.14589.152.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 2/4/10, Peter Tyser <ptyser@xes-inc.com> wrote:

> From: Peter Tyser <ptyser@xes-inc.com>
> Subject: Re: [PATCH 6/7] edac: mpc85xx fsb ecc
> To: dougthompson@xmission.com
> Cc: kolifer@gmail.com, akpm@linux-foundation.org, bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Date: Thursday, February 4, 2010, 10:22 AM
> Hi Doug and Konstantin,
> 
> On Wed, 2010-02-03 at 23:46 -0700, dougthompson@xmission.com
> wrote:
> > From: Konstantin Olifer <kolifer@gmail.com>
> > 
> > Patch is for Kernel 2.6.33. e752x_edac suppose that
> fsb ECC exist, for example, on
> > Celeron + 3100. That is wrong. 
> > ECC FSB supported only on Xeon for our vision
> (www.setdsp.ru) and datasheet from developer intel www. 
> > Fixed.
> > Signed-off-by:  Konstantin Olifer <kolifer@gmail.com>
> > Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
> > ---
> >  e752x_edac.c |   10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> It looks like 6/7 and 7/7 in this series have the wrong
> subject/title.
> Patches 6 and 7 are for the e752x instead of the mpc85xx.

my bad while I was constructing the titles. missed the driver name

thanks andrew for fixing that


doug t


