Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYG2Oxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYG2Oxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYG2OxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:53:18 -0400
Received: from gw.goop.org ([64.81.55.164]:50481 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYG2OxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:53:18 -0400
Message-ID: <488F2EDA.2090709@goop.org>
Date: Tue, 29 Jul 2008 07:53:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oliver.Soltys@rsel.renesas.com
CC: linux-kernel@vger.kernel.org
Subject: Re: directory sort order no longer beginning with "." and ".."?
References: <488EE7BF.4020908@rsel.renesas.com>
In-Reply-To: <488EE7BF.4020908@rsel.renesas.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Soltys wrote:
> My question: is this a bug, or a feature? I could not find anything about that
> anywhere...
>
> Does anybody have an idea, how I can fix this? Unfortunately, our application
> can not be changed.

No Unix-like system makes any guarantee about the order of '.' and '..' 
with respect to other directory entries.  They've often appeared first 
as an implementation side-effect, but that's highly system and 
filesystem dependent.

If you can't modify the app, you might consider some LD_PRELOAD library 
to replace readdir with something that sorts the results in the order 
your app expects.  There's already examples of that kind of thing to 
sort the results by inode.

    J
