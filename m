Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZG3KsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZG3KsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZG3KsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:48:19 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:55073 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZG3KsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:48:19 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 4/4] [perf] fixed faulty check
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       efault@gmx.de
In-Reply-To: <1248949529-20891-1-git-send-email-sgayda2@uiuc.edu>
References: <1248949529-20891-1-git-send-email-sgayda2@uiuc.edu>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 12:51:26 +0200
Message-Id: <1248951086.6391.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 05:25 -0500, Stoyan Gaydarov wrote:
> This patche fixes a spelling error that has resulted from copy and
> pasting. The location of the error was found using a semantic patch
> but the semantic patch was not trying to find these errors. After
> looking things over it seemed logical that this change was needed.
> Please review it and then include the patch if it is in fact the
> correct change.

Looks sane to me. I'll pick it up. Thanks!

> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
> ---
>  tools/perf/util/symbol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 2810605..b4fe057 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -565,7 +565,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  		goto out_elf_end;
>  
>  	secstrs = elf_getdata(sec_strndx, NULL);
> -	if (symstrs == NULL)
> +	if (secstrs == NULL)
>  		goto out_elf_end;
>  
>  	nr_syms = shdr.sh_size / shdr.sh_entsize;

