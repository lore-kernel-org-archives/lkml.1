Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbYBYUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbYBYUET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYBYUED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:04:03 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44370 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758122AbYBYUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:04:00 -0500
X-Sasl-enc: t7dXs5Hi0xccRqzttfHeZK5ZlEaFKfBkkPAEqOA6Cz8H 1203969838
Date: Mon, 25 Feb 2008 17:03:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080225200354.GE16513@khazad-dum.debian.net>
References: <20080225093914.GB4375@ics.muni.cz> <200802251247.30605.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802251247.30605.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Rafael J. Wysocki wrote:
> > 2.6.25-rc2-git7 has regression, thinkpad keys do not work any more.
> > 
> > Probably this commit broke things 6c231bd5eb07ce546517019f334652b9ecfc329a

This commit is indeed broken, and I have a tentative fix for it.  But I'd
like to have a better description of just "how" the thinkpad keys do not
work anymore, to make sure I fix the entire breakage in one go.  I will
stare at the code and the fix a bit more before sending in any patches,
though.

> Also, CCing the author and the relevant list on a report usually is a good
> idea. :-)

Make it "mandatory" if you want a fast reply :^)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
