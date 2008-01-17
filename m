Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYAQTT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYAQTT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYAQTTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:19:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbYAQTTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:19:47 -0500
Date: Thu, 17 Jan 2008 11:19:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.13
Message-Id: <20080117111923.c2418586.akpm@linux-foundation.org>
In-Reply-To: <1200587031.0@pinky>
References: <1200587031.0@pinky>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 16:23:51 -0000 Andy Whitcroft <apw@shadowen.org> wrote:

> This version brings a large number of fixes which have built up over
> the Christmas period.  Mostly these are fixes for false positives, both
> through improvments to unary checks and possible type detection.  It
> also brings new checks for while location and CVS keywords.

heh.  Doctor, heal thyself.


+               
+                               
+                       
warning: update-checkpatchpl-to-version-013 adds trailing whitespace




box:/usr/src/25> perl scripts/checkpatch.pl patches/update-checkpatchpl-to-version-013.patch
ERROR: trailing whitespace
#202: FILE: scripts/checkpatch.pl:344:
+^I^I$

WARNING: line over 80 characters
#279: FILE: scripts/checkpatch.pl:586:
+		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|elif|endif))/o) {

WARNING: line over 80 characters
#441: FILE: scripts/checkpatch.pl:812:
+					($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);

WARNING: line over 80 characters
#450: FILE: scripts/checkpatch.pl:823:
+			if ($linenr == $first_line and $rawline =~ m@^.\s* \*(?:\s|$)@) {

WARNING: line over 80 characters
#473: FILE: scripts/checkpatch.pl:844:
+			($prevrawline, $stashrawline) = ($stashrawline, $rawline);

WARNING: line over 80 characters
#506: FILE: scripts/checkpatch.pl:897:
+			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $herecurr);

WARNING: line over 80 characters
#526: FILE: scripts/checkpatch.pl:916:
+		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length > 80) {

WARNING: line over 80 characters
#548: FILE: scripts/checkpatch.pl:938:
+			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);

ERROR: trailing whitespace
#567: FILE: scripts/checkpatch.pl:950:
+^I^I^I^I$

WARNING: line over 80 characters
#573: FILE: scripts/checkpatch.pl:955:
+			} elsif ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {

WARNING: line over 80 characters
#578: FILE: scripts/checkpatch.pl:959:
+			} elsif ($prev_values eq 'N' && $line =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=)/) {

WARNING: line over 80 characters
#584: FILE: scripts/checkpatch.pl:964:
+			while ($line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/g) {

WARNING: line over 80 characters
#592: FILE: scripts/checkpatch.pl:971:
+			if ($prev_values eq 'N' && $line =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {

WARNING: line over 80 characters
#625: FILE: scripts/checkpatch.pl:1147:
+			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);

WARNING: line over 80 characters
#648: FILE: scripts/checkpatch.pl:1192:
+			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/) {

ERROR: trailing whitespace
#649: FILE: scripts/checkpatch.pl:1193:
+^I^I^I$

WARNING: line over 80 characters
#687: FILE: scripts/checkpatch.pl:1412:
+				ERROR("do not use assignment in if condition\n" . $herecurr);

WARNING: line over 80 characters
#705: FILE: scripts/checkpatch.pl:1448:
+				ERROR("while should follow close brace '}'\n" . $hereprev);

WARNING: line over 80 characters
#718: FILE: scripts/checkpatch.pl:1551:
+				#print "statements<" . scalar(@statements) . ">\n";

WARNING: line over 80 characters
#729: FILE: scripts/checkpatch.pl:1692:
+		print "$vname has no obvious style problems and is ready for submission.\n"

WARNING: line over 80 characters
#733: FILE: scripts/checkpatch.pl:1695:
+		print "$vname has style problems, please review.  If any of these errors\n";

total: 3 errors, 18 warnings, 640 lines checked

patches/update-checkpatchpl-to-version-013.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

