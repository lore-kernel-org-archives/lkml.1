Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYEEGoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYEEGoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYEEGoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:44:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52683 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYEEGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:44:05 -0400
Date: Mon, 5 May 2008 08:35:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <200805051455.02723.rusty@rustcorp.com.au>
Message-ID: <alpine.LNX.1.10.0805050834320.11757@fbirervta.pbzchgretzou.qr>
References: <200805051455.02723.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-05 06:55, Rusty Russell wrote:
>Linus's recent commit said:
>
>   I don't think relying on modversions is the complete answer here.  Perhaps 
>we should make modules_install blow away old modules?

By default, modules_install already removes a great part of
/lib/modules/$(the version you just compiled) AFAIR before installing 
the new ones.
