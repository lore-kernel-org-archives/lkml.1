Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819Ab0AUGUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0AUGUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506Ab0AUGUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:20:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0AUGUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:20:22 -0500
Message-ID: <4B57F2BC.5090403@redhat.com>
Date: Thu, 21 Jan 2010 14:22:52 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf.c: fix a do-while statement.
References: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
In-Reply-To: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Farina wrote:
> warning: do-while statement is not a compound statement
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

Acked-by: WANG Cong <amwang@redhat.com>


> ---
>  fs/binfmt_elf.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index edd90c4..75d6468 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1404,9 +1404,9 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
>  {
>  	elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
>  	int i = 0;
> -	do
> +	do {
>  		i += 2;
> -	while (auxv[i - 2] != AT_NULL);
> +	} while (auxv[i - 2] != AT_NULL);
>  	fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
>  }
>  

