Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYAPTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYAPTNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYAPTNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:13:24 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53581 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbYAPTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:13:23 -0500
X-Sasl-enc: ll2YEmXc2oE4BE6gUgR+2Pr2Q3reoFbIV+E94hlgcTM1 1200510802
Date: Wed, 16 Jan 2008 17:13:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: thinkpad_acpi: define _sta only when needed
Message-ID: <20080116191317.GA29449@khazad-dum.debian.net>
References: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Johannes Weiner wrote:
> Define _sta() helper conditionally; also remove its prototype from
> the internal header and also some other unneeded ones.
> 
> This function is only needed when the bay or the dock subdriver is
> enabled.  Otherwise, gcc complains about an unused static function.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Johannes, thanks for the patches, but NAK.  A similar group of patches that
clean up the _sta and heander file (kills it, actually) has already been
sent to Len Brown to be merged for 2.6.25.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
