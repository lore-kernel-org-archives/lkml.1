Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZK0JhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZK0JhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 04:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZK0JhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 04:37:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZK0JhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:37:05 -0500
Message-ID: <4B0F9DC4.1070509@suse.cz>
Date: Fri, 27 Nov 2009 10:37:08 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Wenji Huang <wenji.huang@oracle.com>
Subject: Re: linux-next: manual merge of the rr tree with the kbuild tree
References: <20091127132254.f9b1fc34.sfr@canb.auug.org.au>
In-Reply-To: <20091127132254.f9b1fc34.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2009 03:22, Stephen Rothwell wrote:
> Hi Rusty,
> 
> Today's linux-next merge of the rr tree got a conflict in
> scripts/mod/modpost.c between commit
> 36021384778b40ffdd59ab34c275786507ef30a6 ("Kbuild: clear marker out of
> modpost") from the kbuild tree and commit
> 215143067b9bfacdfd475c5b2fa5536ee30f50ec ("kbuild: sort the list of
> symbols exported by the kernel (__ksymtab)") from the rr tree.

The "clear marker out of modpost" patch is a no-brainer and when it gets
merged doesn't matter that much. Rusty, would you mind moving it to your
tree? Alternatively, I can disable it in the kbuild tree for a while so
that the two trees don't clash.

Michal
