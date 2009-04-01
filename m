Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZDAUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZDAUzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZDAUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:55:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZDAUzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:55:39 -0400
Message-ID: <49D3D4C0.1080506@zytor.com>
Date: Wed, 01 Apr 2009 13:55:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andreas Robinson <andr345@gmail.com>
CC: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>	 <1238593252-3435-2-git-send-email-andr345@gmail.com>	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
In-Reply-To: <1238613730.10514.35.camel@andreas-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson wrote:
> 
> Perhaps the system can default to the safe decompressor for normal use
> and choose the fast one if STATIC is defined or when system_state ==
> SYSTEM_BOOTING?
> 

Do we really need two pieces of code?  What if we have memory corruption 
during early boot - it seems we'd want to at least try to catch that 
with an error message rather than just crashing.

	-hpa
