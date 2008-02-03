Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbYBCLdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbYBCLdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbYBCLcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:32:52 -0500
Received: from hu-out-0506.google.com ([72.14.214.227]:23620 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYBCLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:subject:message-id;
        b=pA9ew1CuUSu6h1+v51x86VNpRUC2Bz8ZAvEUIZGlN1XvJstDXbutEBPZCAn78z+wErH08a4Z0SYrnLOd5DRIOIzcJ1kkk+pF5ZSwIbPockLLvT5+Sz9GGm+a9Z5Ic+wLV/np6YD0iI6o9lknDkZzkOHPJR3bccmKxB/pBhwd0G4=
User-Agent: quilt/0.46-1
Date: Sun, 03 Feb 2008 14:22:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Subject: [patch 0/4] cleanup - use _AC macro to define PAGE_SIZE
Message-ID: <47a5a65d.03eb300a.07b8.130e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes code duplication for PAGE_SIZE
definition on various architectures.

Please review. Any comments are welcome. *UNTESTED*

Statistics:
 asm-avr32/page.h     |    8 +++-----
 asm-blackfin/page.h  |    8 +++-----
 asm-frv/mem-layout.h |   10 +++-------
 asm-sparc/page.h     |   11 ++++-------

4 files changed, 13 insertions(+), 24 deletions(-)

		- Cyrill -
-- 
