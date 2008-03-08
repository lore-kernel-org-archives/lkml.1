Return-Path: <linux-kernel-owner+w=401wt.eu-S1762552AbYCHBkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762552AbYCHBkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYCHBkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:40:07 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41085 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752515AbYCHBkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:40:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VfXWHJvZnbchP7jHnkDmx5PRokcGiwoX2qcLoIOaEZSWXBrk8aRLTz6+dIaeYLUJTEf+teJjRn+avFwHEVgQLQL4yN4/YuTWh4cqBLjG8w/fVfpZzn9WllJWrbyCs7aeKlaQz810rTOUf4XVa34xbeIqw1l+5lhPExqwI3QWs0Q=  ;
X-YMail-OSG: gIsLEUAVM1lvc79o6U5QUu8JFnPP_tOfpZwkLOgPLFVnYr_GO8c0nF75ghk724lO6Q83Po0Ghw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 5/7] regulator: sysfs ABI
Date: Fri, 7 Mar 2008 17:17:43 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827125.15360.151.camel@a10323.wolfsonmicro.main> <20080307161212.GD28439@kroah.com> <20080307211714.GA26534@sirena.org.uk>
In-Reply-To: <20080307211714.GA26534@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803071717.44028.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2008, Mark Brown wrote:
> On Fri, Mar 07, 2008 at 08:12:12AM -0800, Greg KH wrote:
> > On Thu, Mar 06, 2008 at 06:12:05PM +0000, Liam Girdwood wrote:
> 
> > > +		Some regulator directories will contain a link called parent.
> > > +		This points to the parent or supply regulator if one exists.
> 
> > I don't think this is needed, why not just parent the device properly in
> > the device tree itself?
> 
> The device tree would tend to show parent for the the control interfaces
> for the regulators (typically I2C or SPI) but there is likely to be
> little or no relationship between that and the power distribution in the
> system.

I find "parent" a bit awkward, and Greg won't be the only one to
be asking that question.  Maybe it'd be better named "supply"?

- Dave
