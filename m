Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYA0V0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYA0V0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYA0V0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:26:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34485 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYA0V0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:26:04 -0500
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
From: Peter Zijlstra <peterz@infradead.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Mike Galbraith <efault@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200801272214.49928.toralf.foerster@gmx.de>
References: <479B69D2.5050603@wpkg.org>
	 <200801271339.14668.toralf.foerster@gmx.de>
	 <1201460328.5092.95.camel@homer.simson.net>
	 <200801272214.49928.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=utf-8
Date: Sun, 27 Jan 2008 22:25:58 +0100
Message-Id: <1201469158.6149.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-27 at 22:14 +0100, Toralf Förster wrote:

> Is it correct that within the scenario described above user "A" never gets more
> than 50% of the CPU as soon as user "B" is logged into the system (because of
> the login process itself) ?

No, the login process doesn't normally consume any significant amount of
cpu time.

