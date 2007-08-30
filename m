Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbXH3OHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbXH3OHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXH3OHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:07:06 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:1602 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbXH3OHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:07:04 -0400
X-ME-UUID: 20070830140702486.76CC9700009F@mwinf2a07.orange.fr
Subject: Re: speeding up swapoff
From: Xavier Bestel <xavier.bestel@free.fr>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Robert Hancock <hancockr@shaw.ca>, Daniel Drake <ddrake@brontes3d.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46D6CC35.90207@aitel.hist.no>
References: <fa.j/pO3mTWDugTdvZ3XNr9XpvgzPQ@ifi.uio.no>
	 <fa.ed9fasZXOwVCrbffkPQTX7G3a7g@ifi.uio.no>
	 <fa./NZA3biuO1+qW5pW8ybdZMDWcZs@ifi.uio.no> <46D61F48.5090406@shaw.ca>
	 <46D6CC35.90207@aitel.hist.no>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 16:06:55 +0200
Message-Id: <1188482815.1131.374.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 15:55 +0200, Helge Hafting wrote:
> If the swap device is full, then there is no need for random
> seeks as the swap pages can be read in disk order.

If the swap file is full, you probably have a machine dead into a swap
storm.


