Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZLGFcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZLGFcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZLGFcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:32:07 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:42244 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZLGFcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h5Iuksuo/824VhUS4onIHUNsD6cNxiRPdt0bDMJ34/mLyCno/NlfMXhFRg855X7b7L
         OnGprRe2UUJUAyYTbef4h1pvE/anYTiZCiNW/3XTD/pcLRu0WfP2mv9VzwV4qqqf6VKG
         OPdSlJZU+kADrr9/rArKxWt4MS2nYXAnadkCQ=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: [PATCH 0/2] perf trace/scripting: A couple bugfixes
Date: Sun,  6 Dec 2009 23:31:57 -0600
Message-Id: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fixes a compile error when libperl isn't installed, the other
fixes an annoying message about scripting being unsupported even when
the perf trace cmd isn't trying to use scripting.

Tom Zanussi (2):
  perf trace/scripting: Fix compile err when libperl not installed
  perf trace/scripting: Don't display 'scripting unsupported' msg
    unnecessarily

 tools/perf/util/trace-event-perl.c |   67 +++++++++++++++++++++++++++++------
 tools/perf/util/trace-event-perl.h |    4 ++
 2 files changed, 59 insertions(+), 12 deletions(-)

