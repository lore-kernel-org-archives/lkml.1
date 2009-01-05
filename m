Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZAEWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZAEWUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbZAEWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:19:54 -0500
Received: from eazy.amigager.de ([213.239.192.238]:53863 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZAEWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:19:53 -0500
Date: Mon, 5 Jan 2009 23:19:50 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: No suspend to RAM possible with 2.6.28
Message-ID: <20090105221949.GA2443@x61>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on my ThinkPad X61s, I can not use suspend to RAM anymore. It works
with 2.6.27.

This is what happens:

$ cat /sys/power/state 
mem disk
$ echo mem > /sys/power/state
bash: echo: write error: Device or resource busy
$

Regards,
Tino
