Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbXHWMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbXHWMxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbXHWMxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:53:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36150 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878AbXHWMxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:53:08 -0400
X-Sasl-enc: SApAnAjKmb32jS/5rI2zgrgqVCJfGDVjqGHIswNkweJs 1187873587
Date: Thu, 23 Aug 2007 09:53:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pierre Chifflier <p.chifflier@inl.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: intel_rng: FWH not detected (and no entropy)
Message-ID: <20070823125304.GA22901@khazad-dum.debian.net>
References: <20070823090414.GD22638@piche.inl.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823090414.GD22638@piche.inl.fr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Pierre Chifflier wrote:
> I'm not sure the mhat a hardware RNG is present, so I want to check.

Open the mobo, and locate all FLASH chips.  If one of them is a 82802AB or
82802AC, then you *MIGHT* have an Intel FWH with a HRNG (some of the FWHs
have their RNGs disabled, and since Intel stopped guaranteeing the RNG is
there, they would install one such FWH in their boards just the same).  If
none are a 82802AB or 82802AC, you don't have an Intel FWH with a HRNG.

Even if you had an Intel board that is known to sometimes have an Intel FWH
with an RNG, like the D875PBZ, that wouldn't mean much.  They could have
used an non-Intel equivalent part for that production run, for unknown
reasons.  You really have to check.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
