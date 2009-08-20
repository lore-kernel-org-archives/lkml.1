Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZHTTDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZHTTDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZHTTDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:03:34 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:3545 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZHTTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:03:33 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 15:03:33 EDT
Subject: Re: kernel segv with 2.6.31-rc6 ?
To: deller@gmx.de (Helge Deller)
Date: Thu, 20 Aug 2009 14:55:49 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave.anglin@nrc.ca, deller@gmx.de,
       roland@redhat.com, James.Bottomley@HansenPartnership.com
In-Reply-To: <20090820122537.29410@gmx.net> from "Helge Deller" at Aug 20, 2009 02:25:37 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090820185550.979544E7A@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason seems to be, that something in the newer gcc compilers changed to generate multiple sections all named ".text" for the PCREL17 relocations.
> Older compilers named those sections ".text.1", ".text.2", ".text.3" and so forth.

GCC has never generated ".text.1", etc, on parisc linux as far as I know.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
