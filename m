Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZCOBlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZCOBlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 21:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZCOBla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 21:41:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZCOBla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 21:41:30 -0400
Message-ID: <49BC5BCF.1070602@zytor.com>
Date: Sat, 14 Mar 2009 18:37:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org>
In-Reply-To: <49BC4CAC.202@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On this subject, what is the point of the 64 K "slop space", and if it
is necessary, why not just put it as a RESERVE_BRK() somewhere (*with* a
 significant comment as to its necessity) instead of putting it as a
hack in the linker script?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

