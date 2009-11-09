Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZKJOzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZKJOzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZKJOzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:55:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64848 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZKJOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:55:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=o54DEyL0CDIgqUIraIPUXClzEbBhYyDrVo9XG/T0oZuLaI3fFVvRIsBLA+/9QVWcnn
         S0Vb8ODsb1CNspocmhtNhPAtBHIOpg78X52OMDjdpp546ED+8NOb1F3UT4AZGysBfJLh
         ULeIu5XiWhuQ32fhNlXihLf/Mb9ZccO8s90/Q=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v2 0/2] bsearch: fix overflow and avoid unnecessary calculation
Date: Mon,  9 Nov 2009 12:53:47 -0200
Message-Id: <cover.1257778258.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a rare overflow situation which can occur when working with large arrays.
Also, remove an unneeded calculation.

changelog:
    v2: fix a bug introduced into 00/01 of the v1 patch
    v1: initial submission

André Goddard Rosa (2):
  bsearch: avoid unneeded decrement arithmetic
  bsearch: prevent overflow when computing middle comparison element

 lib/bsearch.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

