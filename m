Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYBASMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYBASMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYBASL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:11:59 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:41001 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbYBASL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:11:58 -0500
Date: Fri, 1 Feb 2008 10:11:57 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: system without RAM on node0 boot fail
In-Reply-To: <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.1.00.0802011011080.14726@twinlark.arctic.org>
References: <200801302026.27130.yinghai.lu@sun.com> <200801302102.09510.yinghai.lu@sun.com> <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

actually yeah i've seen this... in a bizarre failure situation in a system 
which physically had RAM in the boot node but it was never enumerated for 
the kernel (other nodes had RAM which was enumerated).

so technically there was boot node RAM but the kernel never saw it.

-dean

On Wed, 30 Jan 2008, Christoph Lameter wrote:

> x86 supports booting from a node without RAM?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
