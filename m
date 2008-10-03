Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYJCP1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYJCP1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYJCP0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:06 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57484 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 00/13] checkpatch: update to version 0.24
Date: Fri,  3 Oct 2008 16:25:41 +0100
Message-Id: <1223047554-31111-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update brings a large number of small fixes to existing checks.
Of note:

 - fixes up a number of false type detections,
 - code indent checks handle macros and continuation,
 - complex macro detection handles square bracket nesting correctly, and
 - better comment handling for case.

Complete changelog below.

*** BLURB HERE ***

Andy Whitcroft (13):
  checkpatch: do is not a possible type
  checkpatch: labels are not possible types
  checkpatch: handle do without braces if we have enough context
  checkpatch: macros which define structure members are not complex
  checkpatch: accept any sized le/be type
  checkpatch: pull out known acceptable typedefs
  checkpatch: suspect code indent must stop at #else/#elif
  checkpatch: complex macros checks miss square brackets
  checkpatch: DEFINE_ macros are real definitions for exports
  checkpatch: trailing statements ensure we report the end of the line
  checkpatch: suspect indent handle macro continuation
  checkpatch: allow for comments either side of a brace on case
  checkpatch: version: 0.24

 scripts/checkpatch.pl |  110 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 85 insertions(+), 25 deletions(-)

