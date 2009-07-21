Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZGUQZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZGUQZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZGUQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:25:52 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:43872 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZGUQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:25:51 -0400
Subject: Re: Disk access just before shutdown power off.
From: Jon Masters <jonathan@jonmasters.org>
To: James Courtier-Dutton <James@superbug.demon.co.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4A647277.4000009@superbug.demon.co.uk>
References: <4A647277.4000009@superbug.demon.co.uk>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 21 Jul 2009 12:25:44 -0400
Message-Id: <1248193544.4873.1.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 14:34 +0100, James Courtier-Dutton wrote:

> When I shutdown my Linux laptop, it does an orderly shutdown with quite
> a lot of HD activity during shutdown which eventually stops when the
> screen goes blank. Then there is some delay (5-10 seconds) and then a
> quick flurry of HD access just before it powers itself off.

That would be the journal being synced back to disk as an fsync is done
prior to unmounting/remounting-ro. You can't do anything about this
because it needs to be the last thing that is done.

Jon.


