Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYAPNAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYAPNAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYAPNAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:00:40 -0500
Received: from saeurebad.de ([85.214.36.134]:54848 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYAPNAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:00:40 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi@hmh.eng.br
Subject: thinkpad_acpi: define _sta only when needed
Date: Wed, 16 Jan 2008 14:01:42 +0100
Message-Id: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Define _sta() helper conditionally; also remove its prototype from
the internal header and also some other unneeded ones.

This function is only needed when the bay or the dock subdriver is
enabled.  Otherwise, gcc complains about an unused static function.
