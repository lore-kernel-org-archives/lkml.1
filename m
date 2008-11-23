Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYKWI0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYKWI0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYKWI0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:26:14 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:26193 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752774AbYKWI0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:26:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Xg1n/9nxx9qdJA/3WurFIaUG13T1bTfoNCKuKR9kYPnrtAO7WAZhRc6sRVEm79Jk6dEYsJpyN2ZpPihxBiXBYCawDZFMLd2n8CfuOEL3z4TV+UvOB0kx2lL6S5Yqk4UbHRlEpFIVbQlqkXiq1WQu6XCFT+igSZ9NJHHjGxBJ9wY=  ;
X-YMail-OSG: xaLk1oEVM1mkd9i7TA0caidVIcvUFGor_hBwn7WhISv8gQWkIDKNDB.rrQsYoz954r.e7mjqqUcKRT0NFm3uY7kAOb4w0sfd6mXM57OvWQkFhfXwy1DhkfA4yoQcItjDMEZNyyL9NPKz5mbvEoR2unP8CypUxaKm3gfJruw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Sun, 23 Nov 2008 00:26:10 -0800
User-Agent: KMail/1.9.10
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       spi-devel-general@lists.sourceforge.net,
       Stefan Schmidt <stefan@openmoko.org>, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811222059.59806.david-b@pacbell.net> <1227423962.3148.74.camel@brutus>
In-Reply-To: <1227423962.3148.74.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811230026.11126.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Daniel Ribeiro wrote:
> Can you be more descriptive on "address the DMA"? Im not familiar on
> what is the issue here.

You may not pass stack based buffers -- as you're now doing -- for
the spi_transfer buffers.  Documentation/DMA-mapping.txt is very
clear that such buffers are not DMA-safe, and the SPI kerneldoc is
just as clear that spi_transfer.{tx,rx}_buf memory must be DMA-safe.

- Dave

