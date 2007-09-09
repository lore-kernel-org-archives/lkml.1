Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbXIISRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbXIISRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXIISRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:17:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43384 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbXIISRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:17:30 -0400
Date: Sun, 9 Sep 2007 20:17:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Dennis Lubert <plasmahh@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: tsc timer related problems/questions
In-Reply-To: <20070909174935.7c00bbb7@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0709092016120.11640@fbirervta.pbzchgretzou.qr>
References: <1189355506.6255.60.camel@speedy.projectiwear.org>
 <20070909174935.7c00bbb7@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 9 2007 17:49, Arjan van de Ven wrote:
>> 
>> Question: Why are only Intel CPUs considered as stable? Could there be
>> implemented a more sophisticated heuristic, that actually does some
>> tests for tsc stability?
>
>on AMD multi-socket systems, afaik the tsc is not synchronized between
>packages. On Intel the tsc is derived from the FSB which is shared
>between the packages.

Also, the TSC is not necessarily constant wrt. CPU clock speed.
If your program stalls, the core may reduce frequency and hence
TSC values are not linear to time anymore.


	Jan
-- 
