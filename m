Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbZCPXK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbZCPXK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZCPXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:10:10 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:23183 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752893AbZCPXKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:10:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HkAoHG0mZunf/5E80v+D6Jw3IjptUfWOufQgWeUtiIxiKP868Cq+FKWVXePE1MY3kzdPST6T+UItzFaHKbRoclcU/PMr7N8gSATOAGuKMdgCAstX5RZPvkiOeiemuWlkwH5xzLbYbdSA+dTmxveCIg4HU5VxRBtdvjLw7bxMlQE=  ;
X-YMail-OSG: PNNxzmIVM1kBSCPU96SeK.MQ2LeiJ0dtVut986i48nLcV4e6AI3deSwJw3bLX2mvDn9FFGcKjrmV3DJvXD9F0xa.ushmXEXLMk3ZEX8BayXXFbkaoBkg1rwL22DJJXDbBd6eRtX8zHpAxJLv5Wn0V6rv
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v3 0/3] new memory_accessor interface and usage
Date: Mon, 16 Mar 2009 16:10:06 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
In-Reply-To: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903161610.06469.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Kevin Hilman wrote:
> This series adds an interface by which other kernel code can read/write
> persistent memory such as I2C or SPI EEPROMs, or devices which provide
> NVRAM.  Use cases include storage of board-specific configuration data
> like Ethernet addresses and sensor calibrations, etc.

Looks OK to me.  Once this goes in (with support for I2C and SPI EEPROMs)
then various RTC's NVRAM support can be updated too ... at a quick count,
that makes nine more drivers that can easily support this.

I kind of like letting Linux have the option of using this kind of
persistent storage, instead of keeping it so that only bootloaders
(and maybe some userspace code) ever touch it.

- Dave


