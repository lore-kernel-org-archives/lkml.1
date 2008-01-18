Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbYARLg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbYARLg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYARLgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:36:50 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2122 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbYARLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:36:49 -0500
Date: Fri, 18 Jan 2008 11:37:17 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.13
Message-ID: <20080118113717.GE18948@shadowen.org>
References: <1200587031.0@pinky> <20080117111923.c2418586.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117111923.c2418586.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:19:23AM -0800, Andrew Morton wrote:
> On Thu, 17 Jan 2008 16:23:51 -0000 Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > This version brings a large number of fixes which have built up over
> > the Christmas period.  Mostly these are fixes for false positives, both
> > through improvments to unary checks and possible type detection.  It
> > also brings new checks for while location and CVS keywords.
> 
> heh.  Doctor, heal thyself.

Heh, yeah I was feeling pressure to push out the update and forgot to
check it.  Spanner.

I have fixed the three lines which have random tabs on them.  Its
something I do in vi which is adding them, one day I will figure out
what the heck it is I do.

-apw

---
clean up some space violations in checkpatch.pl

Seems that something I do in vi leaves lines with multiple tabs on
them lying about.  Clean these up before edit things more.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 checkpatch.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/checkpatch.pl b/checkpatch.pl
index 07ba401..a2b4c41 100755
--- a/checkpatch.pl
+++ b/checkpatch.pl
@@ -341,7 +341,7 @@ sub sanitise_line {
 		my $clean = 'X' x length($1);
 		$res =~ s@(#\s*(?:error|warning)\s+).*@$1$clean@;
 	}
-		
+
 	return $res;
 }
 
@@ -947,7 +947,7 @@ sub process {
 		if ($realcnt) {
 			# Ignore goto labels.
 			if ($line =~ /$Ident:\*$/) {
-				
+
 			# Ignore functions being called
 			} elsif ($line =~ /^.\s*$Ident\s*\(/) {
 
@@ -1190,7 +1190,7 @@ sub process {
 
 			# Ignore those directives where spaces _are_ permitted.
 			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/) {
-			
+
 			# cpp #define statements have non-optional spaces, ie
 			# if there is a space between the name and the open
 			# parenthesis it is simply not a parameter group.
-- 
