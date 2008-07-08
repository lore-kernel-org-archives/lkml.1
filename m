Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYGHREA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYGHREA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbYGHRDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:03:31 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbYGHRD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:03:29 -0400
Message-Id: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 00/11] CONFIG_KMOD removal
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some place with some code or conditional I just converted to use
CONFIG_MODULES, other places can invoke request_module unconditionally
because it compiles out when the kernel is not modular, and one place
(so far) converted to try_then_request_module.

Comments appreciated.

johannes

