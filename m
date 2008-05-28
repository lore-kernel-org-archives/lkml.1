Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYE1FOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYE1FOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYE1FOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:14:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbYE1FOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:14:35 -0400
Date: Tue, 27 May 2008 22:14:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: [patch -mmotm] docbook: duplicate kernel-locking doc merge
Message-Id: <20080527221419.2f5ca991.akpm@linux-foundation.org>
In-Reply-To: <20080527221327.dfcb4fb6.randy.dunlap@oracle.com>
References: <20080527221327.dfcb4fb6.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 22:13:27 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Removed duplicated patch lines.
> 
> I was checking mmotm (2008-0527) kernel docs and got this error:
> 
> xmlto: input does not validate (status 3)
> /local/linsrc/mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.xml:722: element chapter: validity error : ID trylock-functions already defined
> <chapter id="trylock-functions">
>                                ^
> /local/linsrc/mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.xml:722: element chapter: validity error : ID trylock-functions already defined
> Document /local/linsrc/mmotm-2008-0527-0032/Documentation/DocBook/kernel-locking.xml does not validate
> make[1]: *** [Documentation/DocBook/kernel-locking.html] Error 3
> make[1]: *** Waiting for unfinished jobs....
> make: *** [htmldocs] Error 2
> 
> Looks like Rusty's doc additions were duplicated.

ah, thanks, that's me trying to pick up patches which aren't in linux-next
yet.  I normally don't bother doing that unless there's a lot of material
involved.

I'll zap the erroneously-included
rusty-misc-doc_add_a_chapter_about_trylock_functions_bug_9011.patch
