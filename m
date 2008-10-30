Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYJ3Gf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYJ3Gf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYJ3GfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:35:20 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:28793 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752704AbYJ3GfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:35:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Kjxe2lhJg+X418Em8lfoKKUMfk5kARJXHDcTJHotYuqrGh2j9k5olT/dGfAwR7ntzq0ol62ORf6xvpo/ylRutb/zCOuCrLTIJkVtTHCWJLIhqF8hbc5/7hI/dhX8/ZIYUQ+wTqeHm9cfPxc1wS4FkZRjVH5TbR7d6nyn7q002O4=  ;
X-YMail-OSG: FwWt280VM1levCMBUwKm_ydadPJqX1IeGhaifRVwhkql.h4uabX.Rv0HAm2d_vp77s.SX5MOV1XX7pCzES8eaZU5Li7PWgv5Ts29PhSDHa6mNTRTh9aSW2BXpKBkecA4kCwyd2NaWSqHUELtW4D7hbK.HeemiDOrKgu7un2ZPj_deHaJpXo4z2uq3duX
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: spi: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Wed, 29 Oct 2008 23:35:17 -0700
User-Agent: KMail/1.9.10
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1225330937.5970.99.camel@nga.site>
In-Reply-To: <1225330937.5970.99.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810292335.17631.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2008, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: spi: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... OK by me if this goes into 2.6.28.  There's one more use
of spi->dev.bus_id that I know about, in the spi_gpio driver
currently found in the MM tree.

