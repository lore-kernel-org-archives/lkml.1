Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYAIJcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYAIJcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAIJbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:31:50 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:35520 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYAIJbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:31:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s8Tl2PQWo7I/svLx20LwEa8xNp33dgqo/M+nQxSGLe1irC++SsIl0hvO6FyTPfGwtJLMjnWhpeuH1aE843EDtiozSIEDOx5tdH53d3NdHejfDbACOn6x5xYihYJ3wPe233S1Q888/OwFaW3HRYUDtOCumifkqaJGBEP4oJNi/z0=
Message-ID: <e02b4fed0801090131h40b0e236t49cc0ae4ac147d5c@mail.gmail.com>
Date: Wed, 9 Jan 2008 10:31:45 +0100
From: "David Martin" <taldmd@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Compile-time error with gcc-4.3 on sparc64
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following error compiling latest kernel from git on sparc64
using gcc-4.3:

  CC      arch/sparc64/kernel/signal.o
cc1: warnings being treated as errors
arch/sparc64/kernel/signal.c: En la función 'do_notify_resume':
include/asm/uaccess.h:233: error: el subíndice de la matriz está por
arriba de los límites de la matriz
make[1]: *** [arch/sparc64/kernel/signal.o] Error 1
make: *** [arch/sparc64/kernel] Error 2

("On function 'do_notify resume: error: matrix subindex is over matrix limits")

Compiling with gcc-4.2 it doesn't fail, neither a warning.
