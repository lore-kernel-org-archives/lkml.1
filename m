Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZBRKjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZBRKjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZBRKix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:38:53 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:4696 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZBRKix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:38:53 -0500
Date: Wed, 18 Feb 2009 11:38:47 +0100
From: Olivier Galibert <galibert@pobox.com>
To: "Hack inc." <linux-kernel@vger.kernel.org>
Subject: Can one reach pcmcia attribute space from userspace?
Message-ID: <20090218103847.GB45788@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	"Hack inc." <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a isa-time pcmcia ide flash card that needs to be tickled at
addresses 338000+ in pcmcia attribute space before accepting to answer
to ide commands.  Is there a way to reach that space from userspace?
Or if there isn't, what functions should I look at to reach it from
kernel space (I'll temporarily hack pata_pcmcia.c I guess)?

  OG.

