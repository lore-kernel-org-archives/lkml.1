Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbYCEVkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbYCEVkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYCEVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:40:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:48507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbYCEVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=gdU0LhMoGA4BdW90qNWuu0sEw1l2ytpR/tkvtIpxF+i6Y9jMG6fAc/ucdbOo1marjgVwjXu1KuoCjOQN9Xze7XAd5gERPKwION87knCUO9a1pn2m75vhNy/Jx3cMPUIb1kPT+79NDAARy8biDHgIureZUocpK1uybFj+WepRbPE=
Message-ID: <47CF1320.9000501@gmail.com>
Date: Wed, 05 Mar 2008 22:39:44 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: v3 - Make some text more consinstent and informative
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,
Now messages about missing spaces or not needed spaces are in the format:
space is required
space is not required

New in v2: Fix some spelling mistakes noted by Joe Perches.
New in v3: Fix a spelling error reported by Roel Kluin

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 checkpatch.pl |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/checkpatch.pl b/checkpatch.pl
index 2a7cef9..432729b 100755
--- a/checkpatch.pl
+++ b/checkpatch.pl
@@ -1005,7 +1005,7 @@ sub process {
 					$herecurr);
 			}
 			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("need space after Signed-off-by:\n" .
+				WARN("space is required after Signed-off-by:\n" .
 					$herecurr);
 			}
 		}
@@ -1340,7 +1340,7 @@ sub process {
 			} elsif ("$ctx$name" =~ /$Type$/) {
 
 			} else {
-				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+				WARN("space is not required between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Check operator spacing.
@@ -1424,7 +1424,7 @@ sub process {
 				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEBC]/ &&
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
-						ERROR("need space after that '$op' $at\n" . $hereptr);
+						ERROR("space is required after that '$op' $at\n" . $hereptr);
 					}
 
 				# // is a comment
@@ -1433,13 +1433,13 @@ sub process {
 				# -> should have no spaces
 				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
-						ERROR("no spaces around that '$op' $at\n" . $hereptr);
+						ERROR("spaces are not required around that '$op' $at\n" . $hereptr);
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
-						ERROR("need space after that '$op' $at\n" . $hereptr);
+						ERROR("space is required after that '$op' $at\n" . $hereptr);
 					}
 
 				# '*' as part of a type definition -- reported already.
@@ -1452,10 +1452,10 @@ sub process {
 				} elsif ($op eq '!' || $op eq '~' ||
 				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
-						ERROR("need space before that '$op' $at\n" . $hereptr);
+						ERROR("space is required before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /.xW/) {
-						ERROR("no space after that '$op' $at\n" . $hereptr);
+						ERROR("space is not required after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
@@ -1464,7 +1464,7 @@ sub process {
 						ERROR("need space one side of that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /WxB/ || ($ctx =~ /Wx./ && $cc =~ /^;/)) {
-						ERROR("no space before that '$op' $at\n" . $hereptr);
+						ERROR("space is not required before that '$op' $at\n" . $hereptr);
 					}
 
 				# << and >> may either have or not have spaces both sides
@@ -1514,31 +1514,31 @@ sub process {
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
-			ERROR("need a space before the open brace '{'\n" . $herecurr);
+			ERROR("space is required before the open brace '{'\n" . $herecurr);
 		}
 
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-			ERROR("need a space after that close brace '}'\n" . $herecurr);
+			ERROR("space is required after that close brace '}'\n" . $herecurr);
 		}
 
 # check spacing on square brackets
 		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
-			ERROR("no space after that open square bracket '['\n" . $herecurr);
+			ERROR("space is not required after that open square bracket '['\n" . $herecurr);
 		}
 		if ($line =~ /\s\]/) {
-			ERROR("no space before that close square bracket ']'\n" . $herecurr);
+			ERROR("space is not required before that close square bracket ']'\n" . $herecurr);
 		}
 
 # check spacing on paretheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
-			ERROR("no space after that open parenthesis '('\n" . $herecurr);
+			ERROR("space is not required after that open parenthesis '('\n" . $herecurr);
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/) {
-			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
+			ERROR("space is not required before that close parenthesis ')'\n" . $herecurr);
 		}
 
 #goto labels aren't indented, allow a single space however
@@ -1549,7 +1549,7 @@ sub process {
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-			ERROR("need a space before the open parenthesis '('\n" . $herecurr);
+			ERROR("space is required before the open parenthesis '('\n" . $herecurr);
 		}
 
 # Check for illegal assignment in if conditional.
-- 
1.5.4.950.ga176

