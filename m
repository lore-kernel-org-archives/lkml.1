Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYEXRp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYEXRp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbYEXRpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:45:52 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:34025 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751617AbYEXRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:45:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ivOCZyU3Vkza3J/ZY0oVekQdK2KC/p0iX0H6xqS5HcO3Vi0fqOnMv7pTzZconjHhszeVzUOY+i8z7lDtBo0vWAa/EMSsqH4BqnToUlAa5Xx36165GgQd9Va8iaYqniD7bTVxOjYqqA8d6QtpMrezuNIXdn3A4HEEMRq+/dd8/C8=  ;
X-YMail-OSG: 2YuUyBkVM1kSiKMPKxRC.hbg7GjEaJznz3XD4Z15bGqUvj878AfDUBgc4dlxS8YOSxlXoKwenRcWbMEtcAjyppYC0VtWpfYIdI5i6gbVoDJHw0haWMmq6Fl3vYEMk6.ViAc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Sat, 24 May 2008 10:45:47 -0700
User-Agent: KMail/1.9.9
Cc: "Jochen Friedrich" <jochen@scram.de>, fabrizio.garetto@gmail.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <48384D13.6010608@scram.de> <fa686aa40805241033x128c30b0v826717cc879a712e@mail.gmail.com>
In-Reply-To: <fa686aa40805241033x128c30b0v826717cc879a712e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805241045.47448.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 May 2008, Grant Likely wrote:
> > Isn't the same true for drivers/of/gpio.c or drivers/of/of_i2c.c, as well?
> 
> I would argue 'yes!'

... all the more reason to have the SPI glue go there too,
matching the ACPI/PCI precedent as well as those others!

