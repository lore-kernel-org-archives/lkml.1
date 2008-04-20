Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbYDTUaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbYDTUaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbYDTUaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:30:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbYDTUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:30:06 -0400
Message-ID: <480BA6F3.6030308@zytor.com>
Date: Sun, 20 Apr 2008 16:26:27 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>	<1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>	<480AC505.1030301@zytor.com> <877ies9x6b.fsf@basil.nowhere.org> <480B9856.3040902@gmail.com> <480B9ADD.9060105@zytor.com> <480BA19C.8090608@firstfloor.org>
In-Reply-To: <480BA19C.8090608@firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> It was shipped as AMD K6, but I have no idea if this file is supposed
> to handle real k6s or just early nexgen engineering samples.
> 
> But since it has been basically broken forever (or at least for 
> all of 2.6) it is probably safe to remove until someone complains.
> 

The file only triggers on the "NexGenDriven" CPU signature.  Let's kill it.

	-hpa
