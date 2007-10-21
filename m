Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXJUV6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXJUV6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 17:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbXJUV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 17:58:27 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:55632 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864AbXJUV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 17:58:26 -0400
Date: Sun, 21 Oct 2007 23:58:23 +0200
From: Martin Mares <mj@ucw.cz>
To: Dave Jones <davej@redhat.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Why are ipmi modules being loaded?
Message-ID: <mj+md-20071021.215712.30471.nikam@ucw.cz>
References: <200710211534.11817.elendil@planet.nl> <20071021200936.GG32207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021200936.GG32207@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Hmm, is lspci truncating the class code?
> 
>  > 01:00.4 Serial bus controller [0c07]: Intel Corporation 82573E KCS (Active Management) [8086:108e] (rev 03)
> 
> Because this smells like an IPMI-ish device.

Yes, it is a IPMI class code, only older versions of lspci know nothing
about it, so they at least show the base class (Serial bus controller)
and then add the complete class ID in square brackets.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
"How I need a drink, alcoholic in nature, after the tough chapters involving quantum mechanics!" = \pi
