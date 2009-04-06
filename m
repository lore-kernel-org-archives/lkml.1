Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZDFTwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZDFTwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZDFTwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:52:14 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:33336
	"EHLO QMTA15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZDFTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:52:13 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 15:52:13 EDT
Subject: Re: Replacing VFAT as filesystem on removeable media
From: Nicholas Miell <nmiell@comcast.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Bryan Henderson <hbryan@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <49D90EED.2060703@zytor.com>
References: <OFF614A035.0DA52102-ON8825758C.00613C94-8825758C.006215D5@us.ibm.com>
	 <200904031029.03581.Martin@lichtvoll.de>	<49D8510A.3010606@zytor.com>
	 <20090405153041.08238acf@varda>  <49D90EED.2060703@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Apr 2009 12:46:13 -0700
Message-Id: <1239047173.32425.10.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 13:05 -0700, H. Peter Anvin wrote:
> Alejandro Riveira Fernández wrote:
> >>>
> >> Ironically enough, one of the better filesystems for being supported by
> >> many OSes is probably ext2.  However, that doesn't mean it is even in
> >> the same rough ballpark as (V)FAT.
> > 
> >   What about UDF ?
> 
> Good point.  UDF is probably widely supported, but again, not in the
> same ballpark.  I don't personally know how complex UDF is to implement
> on a small memory device.
> 
> 	-hpa
> 

DVD players are small memory devices and they don't actually implement
UDF.

(DVD movies have UDF filesystems, but they're constructed such that the
files that the DVD player needs are at specific fixed offsets on the
disc, and the DVD player never actually interprets the UDF filesystem.)

Also, there's several different revisions of UDF, which causes some
level of operating system compatibility problems.

Fortunately, the UDF flavor likely to be used on magnetic/flash media is
also the flavor that's the most compatible, so that makes things easier
for everyone.

-- 
Nicholas Miell <nmiell@comcast.net>

