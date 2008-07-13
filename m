Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYGNAAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYGNAAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYGNAAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:00:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbYGNAAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:00:14 -0400
Message-ID: <487A963E.6040307@kernel.org>
Date: Sun, 13 Jul 2008 16:56:46 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/3] x86_64: further cleanup of 32-bit compat syscall
 mechanisms
References: <487877B8.8010505@goop.org>
In-Reply-To: <487877B8.8010505@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> AMD only supports "syscall" from 32-bit compat usermode.
> Intel and Centaur(?) only support "sysenter" from 32-bit compat usermode.
> 
> Set the X86 feature bits accordingly, and set up the vdso in
> accordance with those bits.  On the offchance we run on in a 64-bit
> environment which supports neither syscall nor sysenter from 32-bit
> mode, then fall back to the int $0x80 vdso.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

