Return-Path: <linux-kernel-owner+w=401wt.eu-S933202AbZGPT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbZGPT6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933161AbZGPT6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:58:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34054 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbZGPT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:58:19 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: [PATCH v2 0/3] libata: expose port hotplug information to userspace
Date: Thu, 16 Jul 2009 20:58:07 +0100
Message-Id: <1247774290-4194-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default ALPM policy should be influenced by whether or not it's plausible
for a port to be hotplugged. AHCI provides information on this, but it's
not sufficiently reliable to allow it to be used in-kernel. Exposing this
to userspace allows a more informed policy decision to be made.

