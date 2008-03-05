Return-Path: <linux-kernel-owner+w=401wt.eu-S1762732AbYCEVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732AbYCEVXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761479AbYCEVXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:23:17 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:52891 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761409AbYCEVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:23:16 -0500
Message-ID: <47CF0F42.6070708@tiscali.nl>
Date: Wed, 05 Mar 2008 22:23:14 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH] checkpatch: take 2 - Make some text more consinstent
 and informative
References: <47CF0C30.3060008@gmail.com>
In-Reply-To: <47CF0C30.3060008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
> Hi Andy,
> Now messages about missing spaces or not needed spaces are in the format:
> space is required
> space is not required
> 
> New in v2:
> Fix some spelling mistakes noted by Joe Perches.
> 
> Signed-off-by: unknown <PCIARRO@.omnitel.it>
> ---
> checkpatch.pl |   30 +++++++++++++++---------------
> 1 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/checkpatch.pl b/checkpatch.pl
> index 2a7cef9..ba9fbe6 100755
> --- a/checkpatch.pl
> +++ b/checkpatch.pl
> @@ -1005,7 +1005,7 @@ sub process {
>                     $herecurr);
>             }
>             if ($line =~ /^\s*signed-off-by:\S/i) {
> -                WARN("need space after Signed-off-by:\n" .
> +                WARN("space is required after Signed-off-by:\n" .
>                     $herecurr);
>             }
>         }
> @@ -1340,7 +1340,7 @@ sub process {
>             } elsif ("$ctx$name" =~ /$Type$/) {
> 
>             } else {
> -                WARN("no space between function name and open
> parenthesis '('\n" . $herecurr);
> +                WARN("space is not required between function name and
> open parenthesis '('\n" . $herecurr);
>             }
>         }
> # Check operator spacing.
> @@ -1424,7 +1424,7 @@ sub process {
>                 } elsif ($op eq ';') {
>                     if ($ctx !~ /.x[WEBC]/ &&
>                         $cc !~ /^\\/ && $cc !~ /^;/) {
> -                        ERROR("need space after that '$op' $at\n" .
> $hereptr);
> +                        ERROR("space is required after that '$op'
> $at\n" . $hereptr);
>                     }
> 
>                 # // is a comment
> @@ -1433,13 +1433,13 @@ sub process {
>                 # -> should have no spaces
>                 } elsif ($op eq '->') {
>                     if ($ctx =~ /Wx.|.xW/) {
> -                        ERROR("no spaces around that '$op' $at\n" .
> $hereptr);
> +                        ERROR("space are not required around that '$op'

"spaces are" or "space is"

> $at\n" . $hereptr);
>                     }
> 
>                 # , must have a space on the right.
>                 } elsif ($op eq ',') {
>                     if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
> -                        ERROR("need space after that '$op' $at\n" .
> $hereptr);
> +                        ERROR("space is required after that '$op'
> $at\n" . $hereptr);
>                     }
> 
>                 # '*' as part of a type definition -- reported already.
> @@ -1452,10 +1452,10 @@ sub process {
>                 } elsif ($op eq '!' || $op eq '~' ||
>                          ($is_unary && ($op eq '*' || $op eq '-' || $op
> eq '&'))) {
>                     if ($ctx !~ /[WEBC]x./ && $ca !~
> /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
> -                        ERROR("need space before that '$op' $at\n" .
> $hereptr);
> +                        ERROR("space is required before that '$op'
> $at\n" . $hereptr);
>                     }
>                     if ($ctx =~ /.xW/) {
> -                        ERROR("no space after that '$op' $at\n" .
> $hereptr);
> +                        ERROR("space is not required after that '$op'
> $at\n" . $hereptr);
>                     }
> 
>                 # unary ++ and unary -- are allowed no space on one side.
> @@ -1464,7 +1464,7 @@ sub process {
>                         ERROR("need space one side of that '$op' $at\n"
> . $hereptr);
>                     }
>                     if ($ctx =~ /WxB/ || ($ctx =~ /Wx./ && $cc =~ /^;/)) {
> -                        ERROR("no space before that '$op' $at\n" .
> $hereptr);
> +                        ERROR("space is not required before that '$op'
> $at\n" . $hereptr);
>                     }
> 
>                 # << and >> may either have or not have spaces both sides
> @@ -1514,31 +1514,31 @@ sub process {
> #need space before brace following if, while, etc
>         if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
>             $line =~ /do{/) {
> -            ERROR("need a space before the open brace '{'\n" . $herecurr);
> +            ERROR("space is required before the open brace '{'\n" .
> $herecurr);
>         }
> 
> # closing brace should have a space following it when it has anything
> # on the line
>         if ($line =~ /}(?!(?:,|;|\)))\S/) {
> -            ERROR("need a space after that close brace '}'\n" .
> $herecurr);
> +            ERROR("space is required after that close brace '}'\n" .
> $herecurr);
>         }
> 
> # check spacing on square brackets
>         if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
> -            ERROR("no space after that open square bracket '['\n" .
> $herecurr);
> +            ERROR("space is not required after that open square bracket
> '['\n" . $herecurr);
>         }
>         if ($line =~ /\s\]/) {
> -            ERROR("no space before that close square bracket ']'\n" .
> $herecurr);
> +            ERROR("space is not required before that close square
> bracket ']'\n" . $herecurr);
>         }
> 
> # check spacing on paretheses
>         if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
>             $line !~ /for\s*\(\s+;/) {
> -            ERROR("no space after that open parenthesis '('\n" .
> $herecurr);
> +            ERROR("space is not required after that open parenthesis
> '('\n" . $herecurr);
>         }
>         if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
>             $line !~ /for\s*\(.*;\s+\)/) {
> -            ERROR("no space before that close parenthesis ')'\n" .
> $herecurr);
> +            ERROR("space is not required before that close parenthesis
> ')'\n" . $herecurr);
>         }
> 
> #goto labels aren't indented, allow a single space however
> @@ -1549,7 +1549,7 @@ sub process {
> 
> # Need a space before open parenthesis after if, while etc
>         if ($line=~/\b(if|while|for|switch)\(/) {
> -            ERROR("need a space before the open parenthesis '('\n" .
> $herecurr);
> +            ERROR("space is required before the open parenthesis '('\n"
> . $herecurr);
>         }
> 
> # Check for illegal assignment in if conditional.

