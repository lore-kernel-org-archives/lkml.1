Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbYEGUSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbYEGUSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYEGURy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:17:54 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:41802 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYEGURw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:17:52 -0400
X-ME-UUID: 20080507201750285.45AB91C00091@mwinf1911.orange.fr
Subject: Re: Deleting large files
From: Xavier Bestel <xavier.bestel@free.fr>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Morten Welinder <mwelinder@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0805072208140.30395@fbirervta.pbzchgretzou.qr>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
	 <alpine.LNX.1.10.0805072208140.30395@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 07 May 2008 22:17:36 +0200
Message-Id: <1210191456.14754.1.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 mai 2008 à 22:10 +0200, Jan Engelhardt a écrit :
> 
> >I.e., could unlink do the directory changes and then hand off the rest of the
> >task to a kernel thread?
> 
> Say you had one realtime application running that would do lots of new
> writes after the unlink finished. When the unlink is put into the
> background, you interleave the unlink operation with new writes,
> probably causing needless seeks and therefore not hitting the deadlines
> anymore.

Why ? The writes are delayed, so could be the unlink operations.

	Xav


