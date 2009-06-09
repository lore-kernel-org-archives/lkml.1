Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZFIThI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZFIThI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZFITg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:36:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbZFITg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:36:58 -0400
Date: Tue, 9 Jun 2009 12:36:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] proc.txt: Update kernel filesystem/proc.txt
 documentation
Message-Id: <20090609123641.f4733d8b.akpm@linux-foundation.org>
In-Reply-To: <1244543758.13948.5.camel@wall-e>
References: <1238511505.364.61.camel@matrix>
	<20090401193135.GA12316@elte.hu>
	<1244543758.13948.5.camel@wall-e>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jun 2009 12:35:58 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> This is a patch against the file Documentation/filesystem/proc.txt.
> 
> It is an update for the "Process-Specific Subdirectories" to reflect 
> the changes till kernel 2.6.30. It also introduce the my 
> "provide stack information for threads".

Sorry, but it would be much preferable to do this as two patches.  The
first fixes up proc.txt and the second adds the
stack-information-for-threads material.

This is because the two changes are quite conceptually distinct, and we
might end up wanting to merge one chage and not the other.

