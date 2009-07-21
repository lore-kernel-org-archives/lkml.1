Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZGUROp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZGUROp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZGUROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:14:44 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:45670 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZGUROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LmYmJrP5iamyPn3+RRSee79n4iKg8THpR1iXAwaL96zwm2wgH+Luubu82jPEPamJoN
         6ekR5aNjBcj26nRAGQsURygmN88L8QvBfbc50eU3T/7w28xJ/LeYSl2Ujoa/P3hrY/sc
         rHWtWYSvyYAvYI0qWY7GLCYDM+ejirSEnpPqU=
MIME-Version: 1.0
In-Reply-To: <4A647277.4000009@superbug.demon.co.uk>
References: <4A647277.4000009@superbug.demon.co.uk>
Date: Tue, 21 Jul 2009 19:14:42 +0200
Message-ID: <1158166a0907211014p41b2f5a2x2e61d3cf30e798bb@mail.gmail.com>
Subject: Re: Disk access just before shutdown power off.
From: Denys Vlasenko <vda.linux@googlemail.com>
To: James Courtier-Dutton <James@superbug.demon.co.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 3:34 PM, James
Courtier-Dutton<James@superbug.demon.co.uk> wrote:
> When I shutdown my Linux laptop, it does an orderly shutdown with quite
> a lot of HD activity during shutdown which eventually stops when the
> screen goes blank. Then there is some delay (5-10 seconds) and then a
> quick flurry of HD access just before it powers itself off.

Either your BIOS does something very weird with your disk
when OS commands it to power off (unlikely),

or your system is set up in a way where there is no visible
output when X is killed, but the system (Linux) is still
running (shutting itself down).

Some distributions get fancy ideas about "not scaring users
with this text output scrolling up at boot & shutdown".

This has nice side effect of users not noticing any
potentially useful messages at boot or shutdown. :(

--
vda
