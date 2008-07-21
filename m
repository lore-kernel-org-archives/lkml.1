Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYGUUzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYGUUzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYGUUyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:54:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42830 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYGUUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:54:55 -0400
Date: Mon, 21 Jul 2008 22:54:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
In-Reply-To: <20080721134327.3ffab96f@infradead.org>
Message-ID: <alpine.LNX.1.10.0807212254390.23410@fbirervta.pbzchgretzou.qr>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org> <20080721134327.3ffab96f@infradead.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-07-21 22:43, Arjan van de Ven wrote:

>On Mon, 21 Jul 2008 15:39:44 -0400
>Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> Not all X drivers save and restore fonts on text VTs. Add code to the
>> kernel to explicitly save and restore them on VT switches.
>
>
>do you have a list of which ones don't ?

This piece of code may be needed anyway for swsusp, which does not
restore fonts yet.
