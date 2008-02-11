Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYBKTXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYBKTXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759092AbYBKTWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:22:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910AbYBKTWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:22:39 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com
Subject: [PATCH 0/5] Make vsmp a paravirt client
Date: Mon, 11 Feb 2008 17:09:42 -0200
Message-Id: <1202756982-18244-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of five patches turns the vsmp architecture support in
x86_64 into a paravirt client. If PARAVIRT is on, the probe
function vsmp_init() is run unconditionally, patching the necessary
irq functions accordingly if running ontop of such box.


