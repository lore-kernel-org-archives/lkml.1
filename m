Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbXJJGdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbXJJGdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXJJGdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:33:31 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:39559 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXJJGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:33:30 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: gigabit ethernet power consumption
Date: Wed, 10 Oct 2007 08:35:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20071008220720.GF3484@elf.ucw.cz> <470AAFD7.9060002@intel.com> <20071009182857.GF4003@csclub.uwaterloo.ca>
In-Reply-To: <20071009182857.GF4003@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710100835.05555.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 09 Oktober 2007 schrieb Lennart Sorensen:

> Now if you were trying to transfer a lot of data to the laptop, would it
> be more power efficient to do it at gigabit speeds so you can finish
> sooner and shut down the machine entirely, or to slow to 100mbit and
> take longer to do it, and hence spend more time powering the cpu and
> ram?

There's an amount of data which would be the cutoff point.

But I don't think you can by default make machines slower. So as soon as
the link is saturated you have to switch to the higher speed. To avoid a
ping-pong effect I'd use a timer for bringing the link speed down again.

	Regards
		Oliver



