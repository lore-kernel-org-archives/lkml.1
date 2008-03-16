Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYCPWnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYCPWnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYCPWnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:43:45 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:44678 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752476AbYCPWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:43:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g6lZDcqPq7y2MBMm5DziuQc0QfmILGyEZYoY+PByQBM4nWF+ImZ683wfIElJARTCXNFFYFfKwJ2sVQM7PdskfsJi1pa4E7v66lt3z8GPuzdf17g2W+HokW2v2s/4Nt9Ins5VZLSNZIBLTFQMhbxuzGmy+asFV1lGeBjJspRrVJY=  ;
X-YMail-OSG: 4R63_wkVM1kwRYZDWI3E6k72JM5yGz.FD51vfdXjcTT0yAdk.wx_F8wx8geitVuIEyK8ICq4J7_2qbP2TS7ouGohgF.ConLaaaHOn7utwRODQtXLRA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Chris Wedgwood <cw@f00f.org>
Subject: Re: USB oops with mainline (post 2.6.25-rc5)
Date: Sun, 16 Mar 2008 14:43:37 -0800
User-Agent: KMail/1.9.6
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, linux-kernel@vger.kernel.org,
       Rabeeh Khoury <rabeeh@marvell.com>
References: <20080312093045.GA24017@xi.wantstofly.org> <200803120313.23568.david-b@pacbell.net> <20080316223257.GA4095@puku.stupidest.org>
In-Reply-To: <20080316223257.GA4095@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161543.37993.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Chris Wedgwood wrote:
> On Wed, Mar 12, 2008 at 02:13:23AM -0800, David Brownell wrote:
> 
> > Sorry, I forgot that made it just *after* RC5.  That's the patch I
> > was interested in.
> 
> That's not enough to prevent the oops here.  Using mainline from about
> an hour ago I get a crash inside ub_end_rq.  No full oops (yet) but
> pic at http://stupidest.org/tmp/2.6.25-rc5-cw3-usboops1.png if that

Are you sure it's the same problem?


> helps.  Should I back out all the USB changes of late and see if that
> helps?
> 
> I got that a second or so after inserting a USB storage device.

Does that happen with usb-storage too, or just "ub"?  ISTR hearing
about similar issues specific to "ub".

- Dave


 
