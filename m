Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbZAKFh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbZAKFh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZAKFhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:37:50 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:37378 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZAKFht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:37:49 -0500
Subject: Re: Is it possible for a module to load in use a shared object
	(.so) ?
From: Jon Masters <jonathan@jonmasters.org>
To: joseluismarchetti@yahoo.com.br
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <874675.96328.qm@web34403.mail.mud.yahoo.com>
References: <874675.96328.qm@web34403.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Sun, 11 Jan 2009 00:37:47 -0500
Message-Id: <1231652267.4235.8.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 19:42 -0800, Jose Luis Marchetti wrote:
> Hi,
> 
> I know a module can load another module, but is it possible for a
> module to use a shared object (.so) file ?

Nope. Not directly. The only in-kernel use of "shared objects" is in the
quasi-shared object that is VDSO, but that's entirely different (the
kernel provides what looks like a shared library to userspace).

Also, you probably want to ask these questions on the kernelnewbies
mailing list, and check the archive for similar questions - both of
these questions you asked this evening have come up before :)

Jon.


