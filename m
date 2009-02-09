Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZBIMVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZBIMVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZBIMVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:21:05 -0500
Received: from science.horizon.com ([192.35.100.1]:16294 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754089AbZBIMVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:21:04 -0500
Message-ID: <20090209122101.27925.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Mon, 09 Feb 2009 07:21:01 -0500
To: linux-kernel@vger.kernel.org
Cc: linux@horizon.com
Subject: Is there a way to trigger an interrupt from user-space?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm debugging a driver, and I think an interrupt is getting lost.
Is there something under /proc or /sys that lets me say "pretend like
interrupt #x just arrived", to kick it back into life?

Basically, I want to kill(2) the kernel.

It seems like a sufficiently useful debugging hack that I thought someone
might have implemented it already, although I'm not finding mention of
it anywhere obvious.

(H'm... can the processor generate an arbitrary interrupt by writing to an
MSI address?)
