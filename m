Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXDLXrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXDLXrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXDLXrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:47:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11014 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXDLXrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:47:21 -0400
Date: Thu, 12 Apr 2007 16:48:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] fix tex error when building pdfdocs
Message-Id: <20070412164851.0c5d6e54.randy.dunlap@oracle.com>
In-Reply-To: <20070412203842.GA14245@zmei.tnic>
References: <20070412203842.GA14245@zmei.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 22:38:42 +0200 Borislav Petkov wrote:

> When building pdfdocs, the db2pdf converter bails out because of an
> latex-reserved token  - '#' - in the intermediary .tex file which ends up in a
> conversion error with the following error message: 
> 
> <log>
> [15.0.32])
> ! Incomplete \iffalse; all text was ignored after line 8154.
> <inserted text>
>                 \fi
> <*> kernel-hacking.tex
> </log>
> 
> This is a rather arbitrary fix, so suggest away.

Hi,

I don't have a problem with the change, but I don't get that tex error either.
Here is an extract from the .tex file:


{\def\Element%
{451}\def\ProcessingMode%
{title-sosofo-mode}}\#if\endNode{}\endSeq{}\endLink{}\Seq%
{}\Leader%
{}.\endLeader{}\Link%


> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Index: 21-rc6/Documentation/DocBook/kernel-hacking.tmpl
> ===================================================================
> --- 21-rc6.orig/Documentation/DocBook/kernel-hacking.tmpl
> +++ 21-rc6/Documentation/DocBook/kernel-hacking.tmpl
> @@ -1138,7 +1138,7 @@ static struct block_device_operations op
>    </sect1>
>  
>    <sect1 id="conventions-ifdef">
> -   <title>&num;if</title>
> +   <title>Prepocessor Conditionals</title>
>     
>     <para>
>      It is generally considered cleaner to use macros in header files
> 
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
