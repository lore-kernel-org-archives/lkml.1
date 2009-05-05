Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZEEABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZEEABR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZEEABD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:01:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:18190 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZEEABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:01:01 -0400
MIME-Version: 1.0
Date: Mon, 4 May 2009 17:00:59 -0700
Message-ID: <a24804730905041700i66418576q7b146b05e78884d3@mail.gmail.com>
Subject: const-correctness warnings from gcc -Wwrite-strings?
From: Chris Peterson <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am preparing a patch that would fix some const-correctness warnings
when compiling the kernel with gcc -Wwrite-strings. I am not (yet?)
proposing that the kernel Makefile should use -Wwrite-strings.

String constants are not writable, but without -Wwrite-strings, gcc
pretends string constants have type non-const char[] to support lazy
legacy code. :)

Are these fixes of any interest? The only controversy I see is that
some of the changes affect the function signatures of some ops
structures' function pointers.

chris
