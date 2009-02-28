Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZB1EUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZB1EUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 23:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZB1EUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 23:20:39 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:54998 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZB1EUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 23:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=r17i1TznWZTDAhkN2DyxSLA11+0mOqjUKw05+TshvjnMu1J1+GUGHqzKMCe9w1Kcqd
         7EbclqlGNivx/Ik1SnIap/4sM2LkgajVZms/WrckahGzDxr8hnHgXQ7oJcNUMCJX9fLV
         Uo7AWoWdqXfKEqF5QsojP9UZzlisz//ifHZXE=
Subject: [2.6.29-rc6 regression][bisected] i915 broken STR
From: Harvey Harrison <harvey.harrison@gmail.com>
To: airlied <airlied@linux.ie>, Jesse Barnes <jesse.barnes@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 20:20:34 -0800
Message-Id: <1235794834.5621.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend to RAM fails (screen blanks but does not power down)

2.6.29-rc4 was last working kernel tested, noticed when upgrading
to -rc6

Bisected to:

commit 5669fcacc58bf3a7386057addffd280d75380858
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Feb 17 15:13:31 2009 -0800

    drm/i915: suspend/resume GEM when KMS is active


Harvey

