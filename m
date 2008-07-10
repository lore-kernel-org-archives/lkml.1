Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYGJBpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYGJBpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYGJBo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:44:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYGJBo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:44:56 -0400
Message-ID: <4875697A.2010605@zytor.com>
Date: Wed, 09 Jul 2008 21:44:26 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for RTC on SGI UV
References: <20080709202719.GB22744@sgi.com>
In-Reply-To: <20080709202719.GB22744@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
> [patch] x86 BIOS interface for RTC on SGI UV
> 
> Real-time code needs to know the number of cycles per second
> on SGI UV.  The information is provided via a run time BIOS
> call.  This patch provides the linux side of that interface.
> This is the first of several run time BIOS calls to be defined
> in uv/bios.h and bios_uv.c.
> 
> Note that BIOS_CALL() is just a stub for now.  The bios 
> side is being worked on.
> 

Do you have a proposed specification that could be reviewed before it is 
cast in stone?

	-hpa
