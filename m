Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYHSXKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYHSXKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYHSXKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:10:03 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41806 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbYHSXKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:10:01 -0400
X-Sasl-enc: kGr8P+p1J/LUntkdm4v+cYsiMkNYNel5SilFZ3wxhBaa 1219187399
Date: Tue, 19 Aug 2008 20:09:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, corentincj@iksaif.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] eeepc-laptop: Use standard interfaces
Message-ID: <20080819230950.GC29336@khazad-dum.debian.net>
References: <20080804170833.GA9513@srcf.ucam.org> <20080806092352.GA17801@srcf.ucam.org> <20080806092523.GB17801@srcf.ucam.org> <20080819025815.b5ec1a4c.akpm@linux-foundation.org> <20080819111320.GA19223@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819111320.GA19223@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me at first glance.  I do wonder if there are no events at all
you could hook to rfkill_force_state() instead of (or in addition to) using
the get_state()?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
