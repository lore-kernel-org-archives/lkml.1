Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYH3IhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYH3IhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 04:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYH3IhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 04:37:09 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:53183 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYH3IhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 04:37:08 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48B906B1.3030708@avtrex.com>
Date: Sat, 30 Aug 2008 01:37:05 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 0/6] MIPS: Hardware watch register support for gdb (version
 3).
References: <48B71ADD.601@avtrex.com>
In-Reply-To: <48B71ADD.601@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Aug 2008 08:37:06.0169 (UTC) FILETIME=[9577EE90:01C90A7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> Esteemed kernel hackers,
> 
> To follow is my third pass at MIPS watch register support.
> 

I think there will have to be at least one more pass at this.

The current design assumes that all debug registers support an identical
set of the I, R, and W bits and Mask.

However sections 8.23 and 8.24 of my

  MIPS32® Architecture For Programmers
Volume III: The MIPS32® Privileged Resource Architecture

indicate that they do not have to uniform.  I will have to augment the
ptrace structures to report the values for each register instead of a
single global value.

David Daney

