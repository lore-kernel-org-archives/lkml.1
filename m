Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZGOXM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZGOXM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZGOXMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:12:55 -0400
Received: from web50109.mail.re2.yahoo.com ([206.190.38.37]:44990 "HELO
	web50109.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752159AbZGOXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:12:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=KGODgl38ZjcSkNfcAzaFV/gA+9b5xIxkpokb9q6XTtS/fuON09o4nOtOgQrPdYZDG6uwuOcgoV5NBo7NLraSzDMDWJgCvTd/vcIBANhlhqfkKRHrTrpXridsbNhqlSwahFDv4tk7Y3pmNXMvUW4TFqINn0Fgk6bRYkWms9mEY2c=;
Message-ID: <567174.85150.qm@web50109.mail.re2.yahoo.com>
X-YMail-OSG: Ri4vtB4VM1lVm8VP2y2v8YPpJEXzL94FN9Ufxw6x8ItRXrwcab3g6G8Tdbk3S6aqtgioO1FNePTaSD3kO_xkKOUrlRIpwWMYWev6gultZjALtYz3Xcck2ajf8zgAvAW.gkmAX_AfOIK.OnRLcgMZo3PsLMYzUM.JfKfHHp7CF0ENm7uwd2F0hj2RPsj.9_aJMQ41O2xFfccWMqBdOOtuT__GUdE0K3owLyQSyXOOQ8QqS_Tnlso.YvEZdpX9fOWXX5f8Q2LiwvUQ_g6EQ_nBdmBEZ4dus.pKh0pveD6LVSquBDriKhzzb.3BZkDB3kyM0wAfpifacQ--
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.338.1
Date: Wed, 15 Jul 2009 16:12:54 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/4] edac: mpc85xx add P2020DS support
To: dougthompson@xmission.com, Andrew Morton <akpm@linux-foundation.org>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090715124011.276d2c88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 7/15/09, Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [PATCH 1/4] edac: mpc85xx add P2020DS support
> To: dougthompson@xmission.com
> Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Date: Wednesday, July 15, 2009, 1:40 PM
> On Wed, 15 Jul 2009 11:38:49 -0600
> dougthompson@xmission.com
> wrote:
> 
> > Based on Kumar's new compatible types patch, add P2020
> into
> > MPC85xx EDAC compatible lists so that EDAC can
> recognize
> > P2020 meomry controller and L2 cache controller and
> export
> > the relevant fields to sysfs.
> > 
> > EDAC MPC85xx DDR3 support is needed if DDR3 memory
> stick is
> > installed on a P2020DS board so that EDAC core can
> recognize
> > DDR3 memory type.
> > 
> > Signed-off-by: Yang Shi <yang.shi@windriver.com>
> > Acked-by: Dave Jiang <djiang@mvista.com>
> > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> 
> The way the first two patches were sent indicates that you
> were their
> primary author.  Was that intended?


mmm, darn I missed that. No I am NOT the author. The first signed-off-by lines are the respective authors.

Not intended

> 
> Do you think that any/all of these should be in
> 2.6.31?  2.6.30.x?  If
> so, why?

The x38 fix could probably go into 2.6.31 as that addressing of the register does seem off with an ODD address and might/should cause bad data corruption at best, a fault at worst, IMHO. Maybe 2.6.30 as well

The resource fix patch probably does NOT need to go in, as the code looks to work now as is. It is just cleanup fix.

The mpc83xx patch was okay'd for queue into 2.6.32 only.

the mv64x patch is probably also for 2.6.32 since it is new addition

> 
> Thanks.
> 

thx

doug t
