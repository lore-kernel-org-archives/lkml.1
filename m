Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYF2MVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYF2MVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYF2MVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:21:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42767 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbYF2MVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:21:17 -0400
Message-ID: <48677E39.6000001@firstfloor.org>
Date: Sun, 29 Jun 2008 14:21:13 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Agner Fog <agner@agner.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com> <4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org> <4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org> <20080628200231.GA21259@one.firstfloor.org> <48677313.8000804@qumranet.com>
In-Reply-To: <48677313.8000804@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:

> This is fixable. 

Sure nearly everything is fixable, but why would you want to do that?

For me the best fix currently seems to be to just not do that
when it hurts.

> We could change kernel_fpu_begin() not to disable
> preemption, but instead set a task flag.  When we get the "no device"
> fault, if the flag is set, save the fpu state into the kernel fpu save
> area 

What kernel fpu save area do you mean?

-Andi
