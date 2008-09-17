Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYIQFB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYIQFB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbYIQFBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:01:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:48647 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751283AbYIQFBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:01:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1856cE5FWA5LVibZ8a8lON0RmHQ4VjurZjIVmt9OI
	SBBb8CvpPq1nel
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
In-Reply-To: <1221626391.5043.13.camel@marge.simson.net>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik> <48CAE7A0.8000004@linux-foundation.org>
	 <1221306287.5213.111.camel@marge.simson.net>
	 <48CD1D25.9080301@linux-foundation.org>
	 <1221421907.4597.24.camel@marge.simson.net>
	 <1221475440.4784.39.camel@marge.simson.net>
	 <1221568105.5020.17.camel@marge.simson.net>
	 <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>
	 <1221626391.5043.13.camel@marge.simson.net>
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Sep 2008 07:01:16 +0200
Message-Id: <1221627676.5125.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-17 at 06:40 +0200, Mike Galbraith wrote:
> On Tue, 2008-09-16 at 17:07 +0300, Ilpo Järvinen wrote:

> > One additional sanity check could be to rebase security 6f0f0fd4963 on top 
> > of the c142bda458a and then see if bisection among those security commits 
> > on top yields to the the same result... Though I doubt it can change much 
> > because there was not that much relevant non-security things in the merge 
> > in question.
> 
> I'm not a master of git-foo, so that is not an option.  However, a dinky
> bisection c142bda4..847106f very clearly says...
> 
> marge:..kernel/linux-2.6.27.git # git bisect bad
> 6f0f0fd496333777d53daff21a4e3b28c4d03a6d is first bad commit
> commit 6f0f0fd496333777d53daff21a4e3b28c4d03a6d
> Author: James Morris <jmorris@namei.org>
> Date:   Thu Jul 10 17:02:07 2008 +0900
> 
>     security: remove register_security hook
> 
>     The register security hook is no longer required, as the capability
>     module is always registered.  LSMs wishing to stack capability as
>     a secondary module should do so explicitly.
> 
>     Signed-off-by: James Morris <jmorris@namei.org>
>     Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
>     Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> :040000 040000 0177ef46d305e51e27bfcc4350a40577f8ba8d3d 64b64c10a424df4539653a8ee34f1a2329300931 M      include
> :040000 040000 e318891e514de674fd064f6bfad70d5633b1aff1 0dbb38d5aa7fc3e4b2e09dc65796ce7cd5faeb26 M      security

Which is high grade horse-pookey.

	-Mike

