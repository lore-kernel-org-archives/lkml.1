Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZGKPb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZGKPb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 11:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZGKPbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 11:31:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZGKPbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 11:31:48 -0400
Date: Sat, 11 Jul 2009 12:31:35 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip 3/5] perf report: Make the output more compact
Message-ID: <20090711153135.GJ3452@ghostprotocols.net>
References: <1247325517-12272-1-git-send-email-acme@redhat.com> <1247325517-12272-2-git-send-email-acme@redhat.com> <1247325517-12272-3-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247325517-12272-3-git-send-email-acme@redhat.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jul 11, 2009 at 12:18:35PM -0300, Arnaldo Carvalho de Melo escreveu:
> When we filter by column content we may end up with a column that has the same
> value for all the lines. So remove that column and tell its unique value on the
> top, as a comment.
> 
> Example:

Grr, it should have been:

> [acme@doppio pahole]$  perf report --sort comm,dso,symbol -d ./build/libdwarves.so.1.0.0 -C pahole | head -15
  # dso: ./build/libdwarves.so.1.0.0
  # comm: pahole
  # Samples: 58409
  #
  # Overhead  Symbol
  # ........  ......
  #
>     20.93%  [.] tag__recode_dwarf_type
>     14.94%  [.] namespace__recode_dwarf_types
>     10.38%  [.] cu__table_add_tag
>      6.69%  [.] __die__process_tag
>      5.05%  [.] die__process_function
>      4.70%  [.] list__for_all_tags
>      3.68%  [.] tag__init
>      3.48%  [.] die__create_new_parameter
> [acme@doppio pahole]$

Forgot to add a space before the hashes...

- Arnaldo
