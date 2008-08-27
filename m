Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYH0NYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYH0NYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYH0NYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:24:09 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35773 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbYH0NYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:24:08 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Ignacio Santolin" <lu5ehc@gmail.com>
Subject: Re: Driver needed/broken? "U.S. Robotics Sportster 33600 FAX/Voice Int"
Date: Wed, 27 Aug 2008 15:25:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <854075c50808270610w599c2418wfd97a40261129240@mail.gmail.com> <854075c50808270615o582f9674k2a4282ebf6fa7a34@mail.gmail.com>
In-Reply-To: <854075c50808270615o582f9674k2a4282ebf6fa7a34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271525.22519.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 27 August 2008 15:15:51 schrieb Ignacio Santolin:
> I Using an old modem (U.S. Robotics Sportster 33600 FAX/Voice Int)
> ***NOT WINMODEM***
> 
> Kernel succesfly detects the card (not as modem) and isnt creates the
> /dev/modem (driver develop needed?), Just works sending commands to
> /dev/ttyS1
> NOTE: the modem is not present in any hardware manager or lspci

/dev/modem is a symlink to be created by the management tool of your
distribution. The kernel is not involved.
As for lspci, it lists pci devices. Your modem is isa.

Everything seems the be as it should be from a kernel viewpoint.

	Regards
		Oliver


