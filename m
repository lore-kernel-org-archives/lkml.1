Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZBZS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZBZS4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZBZS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:56:10 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:38986 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752203AbZBZS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:56:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ly4ieWb3uyBj1X69S4n68FZd/SaGksEgidJfCom32iH7DVF8WRgQ3kq0H+InhkufXl+fCqmhBr1fduN9/WnnQWsLGJov5SejzFbMzN3vi20NH1f4RJ1KNtwpYi41XOCxvFEogi4gdsLZIH/sGBViOiXZcZnC7BfqWxyCc56V/ZM=  ;
X-YMail-OSG: WlUaKGAVM1nNIPoKxZoQB7rnshQR82BWO9cDT1wOli1mn1mNseKAGVxDMJlLtF94H_38uYr8lxUMHwiE05Cs7mdrtf1LKDVP1.4PatEQzbnXgeQZcf8mJkQce2TDNfVdqILFNFFe0Rlwdw5UuiJhbulM2zHVVa2SwTA6B0FOL8amALEZxHL6_Yoks65u
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Thu, 26 Feb 2009 10:56:05 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902251702.03230.david-b@pacbell.net> <20090226104624.GA4229@sirena.org.uk>
In-Reply-To: <20090226104624.GA4229@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261056.05740.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Mark Brown wrote:
> On Wed, Feb 25, 2009 at 05:02:03PM -0800, David Brownell wrote:
> 
> > Oh, one more comment.  Requiring manual configuration
> > of fixed-voltage regulators is pure time-wastage.
> 
> Unless, of course, you happen to be using one of those consumers that
> wants to know the voltage it's running at to configure itself.

In which case it can ask the regulator what voltage it's using.  :)

