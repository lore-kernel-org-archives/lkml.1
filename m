Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZIKWAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZIKWAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbZIKWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:00:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57175 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbZIKWAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:00:03 -0400
Date: Fri, 11 Sep 2009 22:59:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: tsuraan <tsuraan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sony-laptop platform driver
Message-ID: <20090911215958.GA30989@srcf.ucam.org>
References: <84fb38e30909110812r23ed0db0y80ae17178395694e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fb38e30909110812r23ed0db0y80ae17178395694e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 10:12:32AM -0500, tsuraan wrote:
> The current mainline sony-laptop platform driver is missing some
> crucial features from Eva's driver
> (http://www.basyskom.org/~eva/log_installation_vaio_z21vnx.html),
> especially the ability to shut off the embedded nvidia card in laptops
> with hybrid graphics.  Simply disabling the nvidia card using Eva's
> driver brings my laptop's power consumption from 18W to 12W, which is
> a pretty huge leap in battery life.

The interface used for that isn't sony-specific, so sony-laptop is the 
wrong place to put it. I've just submitted a patch to the nouveau 
developers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
