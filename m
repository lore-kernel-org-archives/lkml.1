Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZIVOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZIVOsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZIVOsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:48:17 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55139 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbZIVOsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:48:16 -0400
Date: Tue, 22 Sep 2009 16:48:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org
Subject: Re: [PATCH 2/4] kbuild: sort the list of symbols exported by the
	kernel (__ksymtab)
Message-ID: <20090922144819.GB29949@merkur.ravnborg.org>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1253626718-18887-3-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253626718-18887-3-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:38:36PM +0100, Alan Jenkins wrote:
> modpost of vmlinux.o now extracts the ksymtab sections and outputs
> sorted versions of them as .tmp_exports.c.  These sorted sections
> are linked into vmlinux and the original unsorted sections are
> discarded.
> 
> This will allow modules to be loaded faster, resolving symbols using
> binary search, without any increase in the memory needed for the
> symbol tables.
> 
> This does not affect the building of modules, so hopefully it won't
> affect compile times too much.

I do not quite follow you here.

With your patch:

For vmlinux we define our symbols in sections
named *_sorted - but they are not sorted.

We than create a small .c file that uses the original sections names
which is what is used in the final vmlinux.

Could we replace the content of these sections rather than playing
games with the names?

	Sam
