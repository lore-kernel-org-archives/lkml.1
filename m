Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZJTNnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZJTNnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZJTNnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:43:05 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:60611 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751599AbZJTNnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:43:04 -0400
X-Sender-Authentication: net64
Date: Tue, 20 Oct 2009 15:43:05 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: include/asm-generic/int-ll64.h kernel 2.6.31.4
Message-Id: <20091020154305.8338b765.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I lately compiled some app that stumbled across this, and someone smarter than
me should judge if this is right or wrong:


* asm-generic/int-ll64.h
 *
 * Integer declarations for architectures which use "long long"
 * for 64-bit types.
 */

#ifndef _ASM_GENERIC_INT_LL64_H
#define _ASM_GENERIC_INT_LL64_H

#include <asm/bitsperlong.h>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Is it correct to include from linked "asm" instead of asm-generic ?

My link goes to "asm-x86" but for some reason asm-generic/types.h is included
which ends at int-ll64.h trying to include a not existing bitsperlong.h from
directory asm-x86.

-- 
Regards,
Stephan
