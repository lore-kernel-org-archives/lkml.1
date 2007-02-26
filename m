Return-Path: <linux-kernel-owner+w=401wt.eu-S1030373AbXBZS0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373AbXBZS0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030378AbXBZS0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:26:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47956 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030373AbXBZS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:26:11 -0500
X-Sasl-enc: bV82+OEXUFYhOqhFEjLh6VFcugGJ1TMwzTGzHeFZAOMj 1172513826
Date: Mon, 26 Feb 2007 15:17:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling
Message-ID: <20070226181703.GI2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz> <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain> <20070226152035.GB2909@khazad-dum.debian.net> <20070226161203.GD2909@khazad-dum.debian.net> <Pine.LNX.4.64.0702261752050.10496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702261752050.10496@twin.jikos.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Jiri Kosina wrote:
> On Mon, 26 Feb 2007, Henrique de Moraes Holschuh wrote:
> > Improve the backlight code to emulate as much as possible the power
> > management events, as we are unable to really power on or power off the
> > backlight.
> 
> This still easily leads to confusing behavior, doesn't it? As there are 
> power-related calls from backlight driver, which won't get handled 

I failed to notice the power thing, I will update the patch to handle it.
Thanks.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
