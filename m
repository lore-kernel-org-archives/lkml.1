Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYCMFLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYCMFLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYCMFKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:10:14 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:42532 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750764AbYCMFKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:10:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fxhYkhpQTeF89p6tXlljfugGM8hP1NUYN3rk8DUX/ppnyy/VnwclRUNjvoEXD6zL5zQtjbOb235xui4fSkW5q74ghrKmgTFlc0i/icPecO3Jp8AB2TEMl/zBukxgAhNNJfoGQspAwVSdEjn0kKpuAncv3WGhAiXpglOR7l15M3Y=  ;
X-YMail-OSG: i8a6LZ0VM1kXFTrxMxM56L.1p3pUGeaerSGEDU8XBvdVk3j_cfK91jzOvIr0HN9D2DHXKwNgkg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Wed, 12 Mar 2008 21:08:48 -0800
User-Agent: KMail/1.9.6
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803121452.47600.david-b@pacbell.net> <20080312235715.GA15894@opensource.wolfsonmicro.com>
In-Reply-To: <20080312235715.GA15894@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803122208.49040.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Mark Brown wrote:
> On Wed, Mar 12, 2008 at 01:52:46PM -0800, David Brownell wrote:
> > On Wednesday 12 March 2008, Mark Brown wrote:
> 
> > > What do you see as being missing in the externally presented interface?
> 
> > It's not *presented* as a tree of power domains, and it's not clear
> > that's the intended model.  Plus, what Liam said about the names
> > being global, not local/logical.
> 
> Hrm.  I suspect that the documentation which Liam is currently writing
> (together with some actual in-tree users) will help here.

Yes, code is only one part of a balanced architecture.
It's pretty weak at conveying any "big picture" issues,
especially with only one underlying implementation.  If
I can't get that picture without reviewing 100+ KBytes
of code, then something critical is missing...

I've been pushing for clear explanations in part because,
well, nobody else has.  I've come across clear needs for
basic power switching, to manage sections of both SOCs and
boards; and less clear needs for voltage adjustment.  I've
been hoping some of the other folk who have looked at these
issues would chime in.

- Dave


> Right; any regulator API is going to need to cope with connecting
> multiple chips together since that's such a core use case.

