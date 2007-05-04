Return-Path: <linux-kernel-owner+w=401wt.eu-S1422838AbXEDItk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422838AbXEDItk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXEDItj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:49:39 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:50428 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422838AbXEDItj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:49:39 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Fri, 4 May 2007 10:49:20 +0200
User-Agent: KMail/1.9.1
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
In-Reply-To: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041049.20989.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Mai 2007 10:38 schrieb Antonino Ingargiola:
> To solve the problem we must do a complete flush of all the buffer
> chain. I do this flushing the input multiple times with a small pause
> between them. In my case 10 flushes separated by a 10ms pause always
> empties the whole buffer chain, so I get no corruption anymore. I'ts
> not an elegant solution but it works (10 flushes are an overkill but I
> want to be _really_ sure to read the correct data).

How do you flush the buffers? Simply reading them out?

	Regards
		Oliver
