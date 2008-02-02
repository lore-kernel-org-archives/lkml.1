Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbYBBWTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbYBBWTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764225AbYBBWSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:18:46 -0500
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:7422 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762580AbYBBWSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:18:45 -0500
Message-ID: <47A4E7D8.6070006@ntlworld.com>
Date: Sat, 02 Feb 2008 21:59:52 +0000
From: "A.E.Lawrence" <lawrence_a_e@ntlworld.com>
User-Agent: IceDove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 x86 apm module name change not in Kconfig
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy i386 box failed to shutdown under 2.6.24 because it tried to load
module apm rather than apm_32.

If it is intended that apm_32 not be aliased as apm, then
 arch/x86/Kconfig
which currently says "module will be called apm."
needs to be updated to match.

ael

