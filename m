Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbZJPS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbZJPS6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZJPS6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:58:19 -0400
Received: from fifo99.com ([67.223.236.141]:50117 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZJPS6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:58:18 -0400
Subject: Re: [PATCH 6/7] checkpatch: fix false EXPORT_SYMBOL warning
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1255718372-22805-7-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
	 <1255718372-22805-7-git-send-email-apw@canonical.com>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 11:58:21 -0700
Message-Id: <1255719501.22917.54.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 19:39 +0100, Andy Whitcroft wrote:

> -				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
> +#print "FOO A<$lines[$realline_next - 1]> stat<$stat> name<$name>\n";
> +				$suppress_export{$realline_next} = 2;
> +			} else {
> +				$suppress_export{$realline_next} = 1;
>  			}
>  		}
> +		if (!defined $suppress_export{$linenr} &&
> +		    $prevline =~ /^.\s*$/ &&
> +                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
> +		     $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {

ERROR: code indent should use tabs where possible
#148: FILE: scripts/checkpatch.pl:1734:
+                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||$

This one line is spaced over instead of tabbed.. I guess checkpatch can
even check itself, which is nice .. I'm not sure this matters since this
it's perl tho..

Do you apply any kind of coding style to checkpatch itself ?

Daniel




