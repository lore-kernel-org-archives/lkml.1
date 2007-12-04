Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXLDVGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXLDVGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXLDVGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:06:32 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53406
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750898AbXLDVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:06:31 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 00/23] RT balance v7
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:44:25 -0500
Message-ID: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This series applies on GIT commit 2254c2e0184c603f92fc9b81016ff4bb53da622d
(2.6.24-rc4 (ish) git HEAD)

These patches replace v6 + v6b announced here:

http://lkml.org/lkml/2007/11/20/613

 and

http://lkml.org/lkml/2007/11/21/226

The series is a collaborative effort between myself and Steven Rostedt.

Changes since v6:

*) cleaned up patch headers
*) fixed some checkpatch errors
*) incorporated v6<x> add-ons to one unified series

Synopsis:
---------------------

Most people don't care about RT tasks, but some of us do, and this series
helps us fix a problem with the current design.  We designed carefully to have
negligible impact on non RT code paths, and we believe we have achieved this
goal.

These tests against a 64-way SMP architecture show that the series doesn't
hurt those that don't care about RT tasks, but it helps out those that do.

http://people.redhat.com/srostedt/rt-benchmarks/

you can find a tarball of the entire series for your convenience here:

ftp://ftp.novell.com/dev/ghaskins/rt-balance-v7.tar.bz2

also, most of these patches have been incorporated into the later versions of
-rt which you can find in patch form here:

http://www.kernel.org/pub/linux/kernel/projects/rt/

or in prebuilt form here from opensuse-factory:

http://download.opensuse.org/distribution/SL-OSS-factory/inst-source/suse/x86_64/kernel-rt-2.6.24_rc3_git1-3.x86_64.rpm

Please consider for inclusion in the next convenient merge window.

Regards,
-Steven Rostedt, and Gregory Haskins
