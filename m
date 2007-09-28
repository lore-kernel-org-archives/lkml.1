Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXI1Iks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXI1Iks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbXI1Ikk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:40:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbXI1Ikj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:40:39 -0400
Date: Fri, 28 Sep 2007 10:40:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928084003.GA18882@elte.hu>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@shadowen.org> wrote:

> This version brings a number of new checks, and a number of bug fixes.  

your checkpatch patch itself produces 22 warnings ...

i ran it over kernel/sched.c and there are many bogus warnings that i 
reported to you earlier:

  WARNING: multiple assignments should be avoided
  #2319:
  +       max_load = this_load = total_load = total_pwr = 0;

and new bogus ones:

  ERROR: need consistent spacing around '*' (ctx:WxV)
  #5287:
  +               mode_t mode, proc_handler *proc_handler)

  ERROR: need consistent spacing around '*' (ctx:WxV)
  #5328:
  +static ctl_table *sd_alloc_ctl_cpu_table(int cpu)

  ERROR: need space before that '*' (ctx:VxV)
  #209:
  +# define INIT_TASK_GRP_LOAD    2*NICE_0_LOAD

why did you ignore my feedback? Ever since v8 the quality of 
checkpatch.pl has been getting worse and worse as there are way too many 
false positives. I'm still stuck on v8 for my own use, v9 and v10 is 
unusable.

	Ingo

--------------->
WARNING: line over 80 characters
#174: FILE: scripts/checkpatch.pl:572:
+		     $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/)) {

WARNING: line over 80 characters
#186: FILE: scripts/checkpatch.pl:584:
+						(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?

WARNING: line over 80 characters
#200: FILE: scripts/checkpatch.pl:612:
+				ERROR("switch and case should be at the same indent\n$hereline$err");

WARNING: line over 80 characters
#208: FILE: scripts/checkpatch.pl:619:
+			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);

WARNING: line over 80 characters
#213: FILE: scripts/checkpatch.pl:624:
+			# Skip over any removed lines in the context following statement.

WARNING: line over 80 characters
#221: FILE: scripts/checkpatch.pl:635:
+			if ($level == 0 && $ctx =~ /\)\s*\;\s*$/ && defined $lines[$ctx_ln - 1]) {

WARNING: line over 80 characters
#222: FILE: scripts/checkpatch.pl:636:
+				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);

WARNING: line over 80 characters
#224: FILE: scripts/checkpatch.pl:638:
+					WARN("Trailing semicolon indicates no statements, indent implies otherwise\n" .

WARNING: line over 80 characters
#225: FILE: scripts/checkpatch.pl:639:
+						"$here\n$ctx\n$lines[$ctx_ln - 1]");

WARNING: line over 80 characters
#245: FILE: scripts/checkpatch.pl:722:
+		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {

WARNING: line over 80 characters
#250: FILE: scripts/checkpatch.pl:726:
+		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {

WARNING: line over 80 characters
#288: FILE: scripts/checkpatch.pl:842:
+						^.\#\s*define\s+$Ident\s*(?:\([^\)]*\))?|

WARNING: line over 80 characters
#313: FILE: scripts/checkpatch.pl:867:
+						my $before = ctx_expr_before($unary_ctx);

WARNING: line over 80 characters
#314: FILE: scripts/checkpatch.pl:868:
+						if ($before =~ /(?:for|if|while)\s*$/) {

WARNING: line over 80 characters
#320: FILE: scripts/checkpatch.pl:874:
+					if ($op eq '*' && $unary_ctx =~ /$UnaryDefine$/) {

WARNING: line over 80 characters
#326: FILE: scripts/checkpatch.pl:880:
+				#	print "UNARY: <$is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";

WARNING: line over 80 characters
#338: FILE: scripts/checkpatch.pl:905:
+				# '*' as part of a type definition -- reported already.

WARNING: line over 80 characters
#346: FILE: scripts/checkpatch.pl:913:
+				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {

WARNING: line over 80 characters
#347: FILE: scripts/checkpatch.pl:914:
+					if ($ctx !~ /[WEB]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {

WARNING: line over 80 characters
#387: FILE: scripts/checkpatch.pl:932:
+					 $op eq '&' or $op eq '^' or $op eq '|' or

WARNING: line over 80 characters
#432: FILE: scripts/checkpatch.pl:1160:
+			ERROR("Use of $1 is deprecated: see Documentation/spinlocks.txt\n" . $herecurr);

WARNING: line over 80 characters
#456: FILE: scripts/checkpatch.pl:1230:
+			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
