Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbXECGdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbXECGdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXECGdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:33:35 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:38965 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754705AbXECGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:33:34 -0400
Message-ID: <4639822D.2060302@interia.pl>
Date: Thu, 03 May 2007 08:33:17 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
Cc: Tim Hockin <thockin@hockin.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <46379A7E.3000109@interia.pl> <20070501212750.GC31630@sirena.org.uk> <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com> <46382798.2090709@interia.pl> <b3ece790705012303x1e5a2d03xddf6c14aec5a99d8@mail.gmail.com> <463830E1.8080107@interia.pl> <b3ece790705012351g5c0ff8a6g9f2f350ff86f3319@mail.gmail.com> <20070502082211.GD31630@sirena.org.uk> <b3ece790705020744p2e73bb5fo2c0acad947a5de15@mail.gmail.com> <4638EF0B.9050701@interia.pl> <20070502214128.GA4814@sirena.org.uk>
In-Reply-To: <20070502214128.GA4814@sirena.org.uk>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: e2640acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> What about module option?
> 
> That would work, though you crossed in the post with me writing a patch
> adding a sysfs file; I merged the two for overkill (below).  I also have
> a patch which changes the log message for the workaround so that it is
> displayed by default in order to make this easier to diagnose.

Applied. I set default value to 0. Flashed. However
> +	if (!NATSEMI_CREATE_FILE(pdev, dspcfg_workaround))
> +		goto err_create_file;
is going to err_create_file. Without these lines drivers works fine.

Rafa³



----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



