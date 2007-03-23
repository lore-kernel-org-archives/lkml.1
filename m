Return-Path: <linux-kernel-owner+w=401wt.eu-S2992593AbXCWWkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992593AbXCWWkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992594AbXCWWkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:40:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992593AbXCWWkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:40:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=SO74s92P7bWXYwpOnmdWOTVR/uADdQarPyTjKHgQXnSaTDDJqw664BNIGI0CZbnDj
	tBrvZwFscef3j23UpB10Q==
Message-ID: <b040c32a0703231540i56da0877o3da11fcd5929b4e2@mail.gmail.com>
Date: Fri, 23 Mar 2007 15:40:22 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Adam Litke" <agl@us.ibm.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/2] introduce /dev/hugetlb char device
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce /dev/hugetlb device that behaves similar to /dev/zero for
allocating anonymous hugetlb page.  It is especially beneficial that
application developers can have an easy way to create MAP_PRIVATE
hugetlb mappings without all the fuss about the hugetlbfs filesystem.

Two follow on patches has more detail description for each changeset.

Signed-off-by: Ken Chen <kenchen@google.com>
