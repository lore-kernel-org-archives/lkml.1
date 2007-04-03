Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXDCPhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXDCPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXDCPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:37:55 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:52626 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030346AbXDCPhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:37:55 -0400
Date: Tue, 3 Apr 2007 17:37:54 +0200
From: Martin Mares <mj@ucw.cz>
To: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
Message-ID: <mj+md-20070403.153720.5293.nikam@ucw.cz>
References: <46110F88.5040905@gmail.com> <mj+md-20070403.114037.27180.nikam@ucw.cz> <20070403145151.GN26707@cel.leo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403145151.GN26707@cel.leo>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Does whatever defines what these escapes mean, have any comment to make
> about UTF-8? If not, why can't we declare that UTF-8 mode is the "reset"
> mode, the default that would be dropped to on a full reset, and if
> anyone wanted to switch that out to non-default not-UTF-8 mode, they
> could, but that a reset will always reenable it again..?

Maybe it would be a little bit more convenient, but I doubt that such
bit of convenience justifies breaking backward compatibility.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
A computer without Windows is like a chocolate cake without mustard.
