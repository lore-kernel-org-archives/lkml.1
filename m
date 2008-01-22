Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYAVG4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYAVG4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYAVG4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:56:14 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:42699 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752826AbYAVG4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:56:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DU77QpoXrloB1amJFPtD43wmAYiZPxiyXXMLA+vRi58s0kEY6B+f+fBZE1iCkBJCKeeW/0FljV2C0WClFDU5S9Y5rLmtyCgBe1UMji0aOKlFTTSicR4ML947SrzZK35MVDhkMpKTRHlpJ/MpTyaTbr83c5xgohTKrcbYxrM5HhY=  ;
X-YMail-OSG: .ZAjVy0VM1nIBZBCC43W0GMys3LYKkZFXrKSVph4OEQ9Riu7W_huiH6u5xU1ra0SeL_Rf.wQjQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 6/6] spi : use class iteration api
Date: Mon, 21 Jan 2008 22:56:11 -0800
User-Agent: KMail/1.9.6
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <20080112095711.GF2893@darkstar.te-china.tietoenator.com> <20080122060331.GG3066@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080122060331.GG3066@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801212256.11484.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008, Dave Young wrote:
> +static int __spi_master_match(struct device *dev, void *data)
> +{
> +       struct spi_master *m;
> +       u16 *bus_num = (u16 *)data;

That's "void *data" so "u16 *bus_num = data" is preferred.

