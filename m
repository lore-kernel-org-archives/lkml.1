Return-Path: <linux-kernel-owner+w=401wt.eu-S964919AbXBFQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbXBFQJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965005AbXBFQJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:09:36 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919AbXBFQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=QjLL4EmYBXkf/5IFFSihAo3FapLBSEolQWvoqhFk8mthZgLWmOq6bq7Zf6r605QCwj8l3w5E5qNgTDDyaWdUKV0GhqZ54e9nvRkZFetgVBDUdbUqyB0FbTSCW7tPcHdlSDIlVhyOp9SvKRo7RyBbXG6vDJWAJhCIlg3btEwF3GI=
Date: Tue, 6 Feb 2007 18:09:15 +0200
To: toshiba_acpi@memebeam.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] toshiba-acpi: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160915.GO8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index d9b651f..0208d3a 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -125,7 +125,7 @@ static int write_acpi_int(const char *methodName, int val)
 	union acpi_object in_objs[1];
 	acpi_status status;
 
-	params.count = sizeof(in_objs) / sizeof(in_objs[0]);
+	params.count = ARRAY_SIZE(in_objs);
 	params.pointer = in_objs;
 	in_objs[0].type = ACPI_TYPE_INTEGER;
 	in_objs[0].integer.value = val;

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
