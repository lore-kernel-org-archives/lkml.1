Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZF3MGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZF3MGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZF3MG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:06:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46686 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZF3MG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:06:26 -0400
Message-Id: <4A4A1BE50200007800008366@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 13:06:29 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] avoid retaining unnecessary symbol information for
	 loaded modules with kallsyms
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

Signed-off-by: Jan Beulich <jbeulich@novell.com>


