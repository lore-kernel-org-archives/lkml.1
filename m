Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZKLRrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZKLRrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZKLRrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:47:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42166 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753532AbZKLRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:47:40 -0500
Date: Thu, 12 Nov 2009 17:49:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112174916.59fe7805@lxorguk.ukuu.org.uk>
In-Reply-To: <1258047454.16197.1344913359@webmail.messagingengine.com>
References: <4AFACC03.7080209@mayc.ru>
	<4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
	<878web7kwf.fsf@basil.nowhere.org>
	<1258047454.16197.1344913359@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In this case, the problem seems to be access over /dev/mem to stuff the
> kernel is already taking care of.  Certainly "as safe as possible" does

Which is often what is desired - eg debugging driver stuff.

> not have to mean making /dev/mem useless for whatever good uses it has.

It does. Plain and simple.

