Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYBIG26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYBIG26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYBIG2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:28:49 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:33024 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbYBIG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:28:49 -0500
Message-ID: <9803672c0802082228h2c3f543ak8c631fcd3a8077ea@mail.gmail.com>
Date: Sat, 9 Feb 2008 01:28:46 -0500
From: "Mark Tuttle" <marklinux@tuttlelabs.com>
To: linux-kernel@vger.kernel.org
Subject: struct page vs page_link
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding:
commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15

This actually breaks the 802.11 subsystem (http://80211.sf.net) which
relies on the page struct. (ieee80211_crypt_wep.c, line 190) Can
anyone suggest an alternative kernel function or method? As of 2.6.24,
the 802.11 subsystem cannot compile.

Mark Tuttle
