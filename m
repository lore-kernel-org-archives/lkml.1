Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZK3IZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZK3IZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZK3IZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:25:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:37914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZK3IZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:25:02 -0500
Date: Mon, 30 Nov 2009 08:24:25 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259565529-6407-5-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-5-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf trace/scripting: Add Fedora libperl install note to doc
Message-ID: <tip-8ea339adc0a48236008e59dd21564d71c37b331c@git.kernel.org>
Git-Commit-ID: 8ea339adc0a48236008e59dd21564d71c37b331c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ea339adc0a48236008e59dd21564d71c37b331c
Gitweb:     http://git.kernel.org/tip/8ea339adc0a48236008e59dd21564d71c37b331c
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 30 Nov 2009 01:18:49 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Nov 2009 09:04:01 +0100

perf trace/scripting: Add Fedora libperl install note to doc

Fedora needs perl-ExtUtils-Embed for Perl scripting, which also
brings along libperl-devel; note this info for the convenience
of Fedora users.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: anton@samba.org
Cc: hch@infradead.org
LKML-Reference: <1259565529-6407-5-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
