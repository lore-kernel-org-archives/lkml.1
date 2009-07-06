Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZGFNuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZGFNuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZGFNts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:49:48 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23767 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbZGFNtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:49:47 -0400
Message-Id: <4A521D1A0200007800008F91@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 06 Jul 2009 14:49:46 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] avoid retaining unnecessary symbol information for
	 loaded modules with kallsyms (v2)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only defined non-absolute non-section symbols in non-init sections
need to be retained for kallsyms use (and even then in the common case
only text symbols are realy interesting). Therefore, the storage used
for all other symbols can be recovered.

The first patch re-arranges the ELF symbol table accordingly, while the
second patch also optimizaes the referenced string table.

Changes over the initial version: Code slightly re-arranged and a few
comments added according to feedback from Rusty.

Signed-off-by: Jan Beulich <jbeulich@novell.com>


