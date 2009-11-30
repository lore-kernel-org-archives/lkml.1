Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZK3HS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZK3HS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZK3HS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:18:57 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:60621 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZK3HSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w5spulhncm+aRWD3/nFi2RQswsGcTF5OZAKihxjfBiDx+IW639Txak/9HPfluTziE7
         1zUwFZNGVVfrXjk5oxxh/zIKHtfv7jSr8vTS5E0C8Yi+eNtKii+umJnV8CFRKH/7vHda
         +mKc0o7Z+h0s1WcCSgPAU72tHsJIiQ9XT1k9o=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [PATCH 4/4] perf trace/scripting: Add Fedora libperl install note to doc
Date: Mon, 30 Nov 2009 01:18:49 -0600
Message-Id: <1259565529-6407-5-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora needs perl-ExtUtils-Embed for Perl scripting, which also brings
along libperl-devel; note this info for the convenience of Fedora
users.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/README |    4 ++--
 tools/perf/util/trace-event-perl.c             |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/README b/tools/perf/scripts/perl/Perf-Trace-Util/README
index adb99aa..9a97076 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/README
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/README
@@ -36,8 +36,8 @@ INSTALLATION
 Building perf with perf trace Perl scripting should install this
 module in the right place.
 
-You should make sure libperl is installed first e.g. apt-get install
-libperl-dev.
+You should make sure libperl and ExtUtils/Embed.pm are installed first
+e.g. apt-get install libperl-dev or yum install perl-ExtUtils-Embed.
 
 DEPENDENCIES
 
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 2e1cc3c..51e833f 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -577,7 +577,9 @@ struct scripting_ops perl_scripting_ops = {
 void setup_perl_scripting(void)
 {
 	fprintf(stderr, "Perl scripting not supported."
-		"  Install libperl-dev[el] and rebuild perf to get it.\n");
+		"  Install libperl and rebuild perf to enable it.  e.g. "
+		"apt-get install libperl-dev (ubuntu), yum install "
+		"perl-ExtUtils-Embed (Fedora), etc.\n");
 }
 #else
 void setup_perl_scripting(void)
-- 
1.6.4.GIT

