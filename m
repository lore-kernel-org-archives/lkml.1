Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYBRQfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYBRQfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYBRQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:35:34 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31937 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYBRQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:35:33 -0500
Message-Id: <20080218163403.364442547@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Feb 2008 09:34:03 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] simplify initcall & quirk debug output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_fn_descriptor_symbol() prints the address if we don't have a symbol,
so no need to print both.

-- 
