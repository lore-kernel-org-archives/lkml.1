Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYHXBUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYHXBUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 21:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYHXBUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 21:20:08 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:59994 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYHXBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 21:20:07 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fix oops in acer_wmi
Date: Sun, 24 Aug 2008 02:19:41 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080823140509.4b197021@infradead.org>
In-Reply-To: <20080823140509.4b197021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808240219.41946.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 24 Aug 2008 01:19:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008 22:05:09 Arjan van de Ven wrote:
> this is due to a null pointer due to a misordered initialization...
> when the DMI quirks get run, the "interface" variable might not have been
> initialized. The patch below 1) prevents the oops and 2) runs the quirks
> again after all the "interface" initialization has completed.

Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

(Although this patch is missing an SOB from yourself).

> This oops is new in 2.6.27-rc and thus counts as a regression...

NAK - I disagree. This has been broken since day one, there is nothing 
special, as far as I am concerned, about 2.6.27 in this respect.

(If this is showing up that much in kerneloops.org, then I would recommend 
CC'ing it to stable).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
