Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZCTLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZCTLXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCTLXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:23:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57019 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbZCTLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:23:08 -0400
X-Sasl-enc: XqTuGiya3qc76VAPxfYRkxIWShKYvx3Sc6hLIj2MYKNC 1237548185
Date: Fri, 20 Mar 2009 08:23:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: TJ <linux@tjworld.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How? PM suspend resume code in misc driver?
Message-ID: <20090320112303.GA31313@khazad-dum.debian.net>
References: <1237533112.12021.7.camel@hephaestion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237533112.12021.7.camel@hephaestion>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, TJ wrote:
> The precise requirement is to fix a problem for a user of a laptop that
> 'forgets' the state of the RF frequency kill switch during suspend. When
> the PC resumes the radio is off and the hardware button has to be
> manually activated.

Port that driver to rfkill, instead.  It does PM and will do the right
thing across suspend/resume.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
