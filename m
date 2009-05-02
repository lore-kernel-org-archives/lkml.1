Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZEBWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZEBWrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZEBWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:47:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:39214 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZEBWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qCZrvrT42VP/1KxQFmwNsWowNZv1lklkGnyc/Rp1Kk2Tr2cPz40zAfB899DeVcfndo
         Dyz5zzvy+lYwif29z2A1isSi1Twqr4KL3dmHbyY+FFXUTmtjGnFKP2hTXkEq+l4OowvD
         /G2XUEND4L9NE2eHIB992Fba+liZtE6BXg58s=
MIME-Version: 1.0
Date: Sat, 2 May 2009 17:47:07 -0500
Message-ID: <6598f8b90905021547v42564e64t224091a6adb15104@mail.gmail.com>
Subject: x86: atomic.h memory clobbers
From: John Sheu <john.sheu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at include/asm-i386/atomic.h, is there any particular reason
why "memory" is in the clobber list for, say, atomic_sub_and_test, and
not atomic_sub?  As far as I can tell, all the possible memory
operands are already in the in/out lists, and any memory-barrier
concerns (if any) that happen to atomic_sub_and_test should apply
equally for atomic_sub.

-John Sheu
