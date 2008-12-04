Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYLDJ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYLDJ5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYLDJ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:56:59 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:46753 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750845AbYLDJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:56:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lYtC5lOu4ph8i7ZqGR2sSzXI2Rhq+6g4M5EDKbIt29eBshUzSonruRMQ/Gz2OgBkBKRnOa02R1Crx81xYNsag5sVBp6+erqeDnHcvA2Qwz+22EGo3MvSfqYEpZWHsJWDal6kuJM3/W22VTpMsOC1p0NnPHonsUB20Lr9A/s76PE=  ;
X-YMail-OSG: UkMKNKIVM1k9k4BJOSFMuXPBpXm6vmIyKOudMFEBhGcUFqQeshJ6WYmBPjiqP_bJ3Cy6ILJQnELZaGN78JMzlIkG0zTRftRDR9qRB8v6J.R935QY_9Z0LjKFxOGRdONC6II-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com, ext Kwangwoo Lee <kwangwoo.lee@gmail.com>
Subject: Re: [PATCH] Add tsc2007 based touchscreen driver.
Date: Thu, 4 Dec 2008 01:56:54 -0800
User-Agent: KMail/1.9.10
Cc: ext Trilok Soni <soni.trilok@gmail.com>, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
References: <483a38b80812020539v2323a784h7f202749687764db@mail.gmail.com> <483a38b80812032107i761fb9bdkba9b2ce5e998ae6a@mail.gmail.com> <20081204093715.GH10209@gandalf.research.nokia.com>
In-Reply-To: <20081204093715.GH10209@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040156.55943.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008, Felipe Balbi wrote:
> i2c subsystem has smbus emulation. The special reason is just that it's
> simpler for the driver writer ;-)

I'd have said "more portable", actually.  I2C hosts can
do pretty much everything an SMBus host can, but the
converse is not true.

And re i2c_check_functionality() ... yes, use it to make
sure each I2C or SMBus call the driver makes is supported
by the underlying controller.

- Dave

