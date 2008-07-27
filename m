Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYG0Dbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYG0Dbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYG0Dbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:31:44 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37162 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373AbYG0Dbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:31:43 -0400
X-Sasl-enc: VQ2IWHXMcz0RwWOYlMwWYurBAVdDffWRf6V2ZZtDJSdm 1217129502
Date: Sun, 27 Jul 2008 00:31:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Hugh Dickins <hugh@veritas.com>
Cc: Kel Modderman <kel@otaku42.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: tmpfs: kernel BUG at mm/shmem.c:814
Message-ID: <20080727033137.GA3489@khazad-dum.debian.net>
References: <200807262210.11502.kel@otaku42.de> <Pine.LNX.4.64.0807262318050.25997@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807262318050.25997@blonde.site>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Hugh Dickins wrote:
> on 2.6.26.  It's using posix_fadvise on directories, and the shmem_readpage
> method added in 2.6.23 is letting POSIX_FADV_WILLNEED allocate useless pages
...

> Cc: stable@kernel.org

Is the fix needed on 2.6.25 as well?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
