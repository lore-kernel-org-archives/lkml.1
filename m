Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZK1KWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZK1KWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 05:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZK1KWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 05:22:30 -0500
Received: from ozlabs.org ([203.10.76.45]:59593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZK1KW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 05:22:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: linux-next: manual merge of the rr tree with the kbuild tree
Date: Sat, 28 Nov 2009 20:52:33 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Wenji Huang <wenji.huang@oracle.com>
References: <20091127132254.f9b1fc34.sfr@canb.auug.org.au> <4B0F9DC4.1070509@suse.cz>
In-Reply-To: <4B0F9DC4.1070509@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911282052.33651.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 08:07:08 pm Michal Marek wrote:
> On 27.11.2009 03:22, Stephen Rothwell wrote:
> > Hi Rusty,
> > 
> > Today's linux-next merge of the rr tree got a conflict in
> > scripts/mod/modpost.c between commit
> > 36021384778b40ffdd59ab34c275786507ef30a6 ("Kbuild: clear marker out of
> > modpost") from the kbuild tree and commit
> > 215143067b9bfacdfd475c5b2fa5536ee30f50ec ("kbuild: sort the list of
> > symbols exported by the kernel (__ksymtab)") from the rr tree.
> 
> The "clear marker out of modpost" patch is a no-brainer and when it gets
> merged doesn't matter that much. Rusty, would you mind moving it to your
> tree? Alternatively, I can disable it in the kbuild tree for a while so
> that the two trees don't clash.

OK, I've taken this into my tree and adjusted accordingly.  As you say,
it's trivial.

Thanks!
Rusty.
