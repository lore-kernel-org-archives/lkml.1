Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZBZBCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZBZBCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZBZBCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 20:02:08 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:44685 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753038AbZBZBCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 20:02:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xq2g4aAVAkzbG56wDmzuVebOa64oKvqfPuQtSPM2adIftvFMui6t8XfRxTLFUSpaEvSp+8CXM9KgwUWkjuQUET1JqmrrGwDjv2oMny2RiBVwciMCAXDIAFeRktvH8i3i5cpxMKNe2om/DgH7cFLbJUeGfhshw+bv4KMC+yTN9u0=  ;
X-YMail-OSG: IJ4Rh0YVM1nxtfY043KbXL1gqD4rYhPQs9FozBS0ntWA1DZ.shMm2W96tUEJiF90Ef3iwVoxJ5oUGupQXpOf908xJLf_DD.iksFuhNMOEInaiBZO32nM0zELoVbC8paXWs2RTNfm3Vd2FGBERUlifK5uud4U6hi35AmiDRcCxh9S3v8GxjufAw34bm9n
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Wed, 25 Feb 2009 17:02:03 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902241617.22643.david-b@pacbell.net> <20090225151721.GA31637@sirena.org.uk>
In-Reply-To: <20090225151721.GA31637@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902251702.03230.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009, Mark Brown wrote:
> > Fixable in an update.  I still think it's better to require less
> > manual configuration, not more ... manual configuration is by
> > definition error prone; requiring more manual configuration makes
> 
> This whole interface is structured around the idea that the consequences
> of getting this wrong include things like lasting hardware damage.

Oh, one more comment.  Requiring manual configuration
of fixed-voltage regulators is pure time-wastage.

